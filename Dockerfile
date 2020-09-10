# Ver: 1.2 by Endial Fang (endial@126.com)
#
FROM debian:buster-slim

# APT源配置：default / tencent / ustc / aliyun / huawei
ARG apt_source=tencent

ENV APP_USER=builder

LABEL \
	"Version"="v10" \
	"Description"="Docker image for Builder based on Debian." \
	"Dockerfile"="https://github.com/colovu/docker-builder" \
	"Vendor"="Endial Fang (endial@126.com)"

COPY prebuilds /
COPY customer /
RUN select_source ${apt_source}
RUN install_pkg sudo wget curl git ca-certificates iproute2 net-tools nano dpkg gnupg dirmngr apt-utils apt-transport-https lsb-release iputils-ping build-essential cmake libcmocka-dev
RUN prepare_env && create_user

CMD []