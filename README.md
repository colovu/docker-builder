# Builder

预安装常用工具及编译工具的镜像。

该镜像主要用于在使用多阶段方式制作镜像时，进行软件的下载、编译等预处理操作。预安装软件包节省软件包下载及更新时间。

**版本信息：**

- latest

**镜像信息：**

* 镜像地址：
  * colovu/debian-builder:latest
  * colovu/alpine-builder:latest

## 数据卷

镜像默认提供以下数据卷定义：

```shell
 /srv/data			# 工作目录
 /srv/conf		# 配置文件目录
```

## 使用方式

使用`--from=0`方式：

```dockerfile
# 预编译阶段
FROM alpine-builder

WORKDIR /build
RUN \
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	gosu_ver=1.12; \
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${gosu_ver}/gosu-$dpkgArch"; \
	chmod +x /usr/local/bin/gosu;

# 镜像生成阶段
FROM scratch

# 从编译阶段的中拷贝编译结果到当前镜像中
COPY --from=0 /usr/local/bin/gosu /usr/local/bin/
CMD []
```

使用`--from=name`方式：

```dockerfile
# 预编译阶段。命名为`builder`
FROM alpine-builder as builder

# ... 省略

# 镜像生成阶段
FROM scratch

# 从编译阶段的中拷贝编译结果到当前镜像中
COPY --from=builder /usr/local/bin/gosu /usr/local/bin/
CMD []
```

使用该方式的优势：

- 因系统相关软件包已更新，工具已经预先安装，不需要在每次编译镜像时耗费大量时间在类似重复工作上

- 不用安装、删除临时软件，方式生成多余的垃圾文件；预编译阶段的内容使用完即丢弃，不会对镜像大小产生影响

  



----

本文原始来源 [Endial Fang](https://github.com/colovu) @ [Github.com](https://github.com)

