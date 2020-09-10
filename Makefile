# Ver: 1.4 by Endial Fang (endial@126.com)
#
# 当前 Docker 镜像的编译脚本

debian_name := colovu/dbuilder
alpine_name := colovu/abuilder
local_registory := repo-dev.konkawise.com

# 生成镜像TAG，类似：
# 	<镜像名>:<分支名>-<Git ID>		# Git 仓库且无文件修改直接编译 	
# 	<镜像名>:<分支名>-<年月日>-<时分秒>		# Git 仓库有文件修改后的编译
# 	<镜像名>:latest-<年月日>-<时分秒>		# 非 Git 仓库编译
current_subversion:=$(shell if [[ -d .git ]]; then git rev-parse --short HEAD; else date +%y%m%d-%H%M%S; fi)
current_tag:=$(shell if [[ -d .git ]]; then git rev-parse --abbrev-ref HEAD | sed -e 's/master/latest/'; else echo "latest"; fi)-$(current_subversion)

# Sources List: default / tencent / ustc / aliyun / huawei
build-arg:=--build-arg apt_source=tencent

# 设置本地下载服务器路径，加速调试时的本地编译速度
local_ip:=`ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $$2}'|tr -d "addr:"`
build-arg+=--build-arg local_url=http://$(local_ip)/dist-files

.PHONY: build clean clearclean upgrade tag push

build:
	@echo "Build $(debian_name):$(current_tag)"
	@docker build --force-rm $(build-arg) -t $(debian_name):$(current_tag) .
	@echo "Add tag: $(debian_name):latest"
	@docker tag "$(debian_name):$(current_tag)" $(debian_name):latest
	@echo "Build $(alpine_name):$(current_tag)"
	@docker build --force-rm $(build-arg) -t $(alpine_name):$(current_tag) ./alpine
	@echo "Add tag: $(alpine_name):latest"
	@docker tag "$(alpine_name):$(current_tag)" $(alpine_name):latest

# 清理悬空的镜像（无TAG）及停止的容器 
clean:
	@echo "Clean untaged images and stoped containers..."
	@docker ps -a | grep "Exited" | awk '{print $$1}' | xargs docker rm
	@docker images | grep '<none>' | awk '{print $$3}' | xargs docker rmi -f

clearclean: clean
	@echo "Clean all images for current application..."
	@docker images | grep "$(debian_name) " | awk '{print $$3}' | xargs docker rmi -f
	@docker images | grep "$(alpine_name) " | awk '{print $$3}' | xargs docker rmi -f

tag:
	@echo "Add tag: $(local_registory)/$(debian_name):latest"
	@docker tag $(debian_name):latest $(local_registory)/$(debian_name):latest
	@echo "Add tag: $(local_registory)/$(alpine_name):latest"
	@docker tag $(alpine_name):latest $(local_registory)/$(alpine_name):latest

push: tag
	@echo "Push: $(local_registory)/$(debian_name):latest"
	@docker push $(local_registory)/$(debian_name):latest
	@echo "Push: $(local_registory)/$(alpine_name):latest"
	@docker push $(local_registory)/$(alpine_name):latest
	@echo "Push: $(debian_name):latest"
	@docker push $(debian_name):latest
	@echo "Push: $(alpine_name):latest"
	@docker push $(alpine_name):latest

# 更新所有 colovu 仓库的镜像 
upgrade: 
	@echo "Upgrade all images..."
	@docker images | grep 'colovu' | grep -v '<none>' | grep -v "latest-" | awk '{print $$1":"$$2}' | xargs -L 1 docker pull
