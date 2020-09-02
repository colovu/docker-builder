# Ver: 1.0 by Endial Fang (endial@126.com)
#
FROM alpine:3.12

# ARG参数使用"--build-arg"指定。如 "--build-arg apt_source=tencent"
# APK源配置：default / tencent / ustc / aliyun / huawei
ARG apt_source=tencent

# 定义应用基础目录信息，该常量在容器内可使用
ENV	APP_CONF_DIR=/srv/conf \
	APP_DATA_DIR=/srv/data

LABEL \
    "Version"="v3.12" \
	"Description"="Docker image for Builder based on Alpine." \
	"Dockerfile"="https://github.com/colovu/docker-builder" \
	"Vendor"="Endial Fang (endial@126.com)"

# 拷贝默认 Shell 脚本至容器相关目录中
COPY prebuilds /
COPY sources/* /etc/apk/

RUN set -eux; \
	\
# 更改源为当次编译指定的源
	cp /etc/apk/repositories.${apt_source} /etc/apk/repositories; \
	\
	apk update --no-cache ; \
	apk upgrade --no-cache ; \
	\
	export APP_DIRS="${APP_CONF_DIR} ${APP_DATA_DIR}"; \
	mkdir -p ${APP_DIRS}; \
	\
	fetchDeps=" \
		bash \
		curl ca-certificates \
		iproute2 net-tools \
		\
		nano \
		build-base \
		\
		gnupg dpkg \
	"; \
	apk add --no-cache ${fetchDeps};

CMD []
