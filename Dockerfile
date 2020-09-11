# Ver: 1.2 by Endial Fang (endial@126.com)
#
FROM debian:buster-slim

# APT源配置：default / tencent / ustc / aliyun / huawei
ARG apt_source=tencent

ENV APP_NAME=dbuilder \
	APP_USER=builder

LABEL \
	"Version"="v10" \
	"Description"="Docker image for Builder based on Debian." \
	"Dockerfile"="https://github.com/colovu/docker-builder" \
	"Vendor"="Endial Fang (endial@126.com)"

COPY prebuilds /
COPY customer /
RUN select_source ${apt_source}

# 以下命令安装的软件包
# apt-transport-https apt-utils binutils binutils-common
#  binutils-x86-64-linux-gnu build-essential bzip2 ca-certificates cmake
#  cmake-data cpp cpp-8 curl dirmngr distro-info-data dpkg-dev g++ g++-8 gcc
#  gcc-8 git git-man gnupg gnupg-l10n gnupg-utils gpg gpg-agent gpg-wks-client
#  gpg-wks-server gpgconf gpgsm iproute2 iputils-ping libapt-inst2.0
#  libarchive13 libasan5 libassuan0 libatomic1 libbinutils libc-dev-bin
#  libc6-dev libcap2 libcap2-bin libcc1-0 libcmocka-dev libcmocka0
#  libcurl3-gnutls libcurl4 libdpkg-perl libelf1 liberror-perl libexpat1
#  libgcc-8-dev libgdbm-compat4 libgdbm6 libglib2.0-0 libgomp1 libgssapi-krb5-2
#  libicu63 libisl19 libitm1 libjsoncpp1 libk5crypto3 libkeyutils1 libkrb5-3
#  libkrb5support0 libksba8 libldap-2.4-2 libldap-common liblsan0 libmnl0
#  libmpc3 libmpdec2 libmpfr6 libmpx2 libncurses6 libnghttp2-14 libnpth0
#  libpcre2-8-0 libperl5.28 libprocps7 libpsl5 libpython3-stdlib
#  libpython3.7-minimal libpython3.7-stdlib libquadmath0 libreadline7 librhash0
#  librtmp1 libsasl2-2 libsasl2-modules-db libsqlite3-0 libssh2-1 libssl-dev
#  libssl1.1 libstdc++-8-dev libtsan0 libubsan1 libuv1 libxml2 libxtables12
#  linux-libc-dev lsb-base lsb-release make mime-support nano net-tools openssl
#  patch perl perl-modules-5.28 pinentry-curses pkg-config procps python3
#  python3-minimal python3.7 python3.7-minimal readline-common sudo wget
#  xz-utils
RUN install_pkg sudo wget curl git ca-certificates iproute2 net-tools nano \
		dpkg gnupg dirmngr apt-utils apt-transport-https lsb-release iputils-ping \
		build-essential cmake libcmocka-dev pkg-config libssl-dev

RUN prepare_env && create_user

CMD []