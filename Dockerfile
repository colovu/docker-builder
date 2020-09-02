# Ver: 1.0 by Endial Fang (endial@126.com)
#
FROM debian:buster-slim

# ARG参数使用"--build-arg"指定。如 "--build-arg apt_source=tencent"
# APT源配置：default / tencent / ustc / aliyun / huawei
ARG apt_source=tencent

# 定义应用基础目录信息，该常量在容器内可使用
ENV	APP_CONF_DIR=/srv/conf \
	APP_DATA_DIR=/srv/data

LABEL \
	"Version"="v10" \
	"Description"="Docker image for Builder based on Debian." \
	"Dockerfile"="https://github.com/colovu/docker-builder" \
	"Vendor"="Endial Fang (endial@126.com)"

# 拷贝默认 Shell 脚本至容器相关目录中
COPY prebuilds /
COPY sources /etc/apt/sources/

# shell 执行参数，分别为 -e(命令执行错误则退出脚本) -u(变量未定义则报错) -x(打印实际待执行的命令行)
RUN export DEBIAN_FRONTEND=noninteractive; \
	set -eux; \
	\
	cp /etc/apt/sources/sources.list.${apt_source} /etc/apt/sources.list; \
	apt-get update; \
#	apt-get upgrade -y; \
	\
	export APP_DIRS="${APP_CONF_DIR} ${APP_DATA_DIR}"; \
	mkdir -p ${APP_DIRS}; \
	\
	fetchDeps=" \
		wget curl ca-certificates apt-transport-https \
		lsb-release iproute2 net-tools iputils-ping \
		\
		nano \
		build-essential \
	"; \
	apt-get install -y --no-install-recommends ${fetchDeps}; \
	apt-get purge -y --auto-remove; \
	apt-get autoclean -y; \
	rm -rf /var/lib/apt/lists/*;

CMD []
