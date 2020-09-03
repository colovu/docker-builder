# Ver: 1.0 by Endial Fang (endial@126.com)
#
FROM alpine:3.12

# APK源配置：default / tencent / ustc / aliyun / huawei
ARG apk_source=tencent

LABEL \
    "Version"="v3.12" \
	"Description"="Docker image for Builder based on Alpine." \
	"Dockerfile"="https://github.com/colovu/docker-builder" \
	"Vendor"="Endial Fang (endial@126.com)"

COPY prebuilds /
COPY customer /
RUN select_source ${apt_source}
RUN install_pkg sudo bash nano build-base curl ca-certificates iproute2 net-tools gnupg dpkg
RUN prepare_env && create_user

CMD []