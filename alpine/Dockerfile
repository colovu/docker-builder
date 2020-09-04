# Ver: 1.0 by Endial Fang (endial@126.com)
#
FROM alpine:3.12

# 说明：
#	虽然原始镜像包含 wget, 但该版本存在问题，下载部分资源（如redis）会报错，因此安装官方完整版

# APK源配置：default / tencent / ustc / aliyun / huawei
ARG apt_source=tencent

LABEL \
    "Version"="v3.12" \
	"Description"="Docker image for Builder based on Alpine." \
	"Dockerfile"="https://github.com/colovu/docker-builder" \
	"Vendor"="Endial Fang (endial@126.com)"

COPY prebuilds /
COPY customer /
RUN select_source ${apt_source}
RUN install_pkg sudo wget git curl ca-certificates iproute2 net-tools nano dpkg gnupg bash build-base
RUN prepare_env && create_user

CMD []