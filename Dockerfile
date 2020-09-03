# Ver: 1.0 by Endial Fang (endial@126.com)
#
FROM debian:buster-slim

# APT源配置：default / tencent / ustc / aliyun / huawei
ARG apt_source=tencent

LABEL \
	"Version"="v10" \
	"Description"="Docker image for Builder based on Debian." \
	"Dockerfile"="https://github.com/colovu/docker-builder" \
	"Vendor"="Endial Fang (endial@126.com)"

COPY prebuilds /
COPY customer /
RUN select_source ${apt_source}
RUN install_pkg sudo wget curl ca-certificates gnupg dirmngr dpkg apt-transport-https lsb-release iproute2 net-tools iputils-ping nano build-essential
RUN prepare_env && create_user

CMD []