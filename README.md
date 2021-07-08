# Builder

预安装常用工具及编译工具的镜像。

该镜像为基于 Debian 系统的 Builder 环境，主要用于在使用多阶段方式制作镜像时，进行软件的下载、编译等预处理操作。预安装软件包节省软件包下载及更新时间。


**版本信息：**

- latest

**镜像信息：**

* 镜像地址：
  - Aliyun仓库：registry.cn-shenzhen.aliyuncs.com/colovu/dbuilder
  - DockerHub：colovu/dbuilder
  * 依赖镜像：colovu/debian

> 后续相关命令行默认使用`[Docker Hub](https://hub.docker.com)`镜像服务器做说明



## TL;DR

Docker 快速启动命令：

```shell
# 从 Docker Hub 服务器下载镜像并启动
$ docker run -it colovu/dbuilder /bin/bash
```



## 数据卷

镜像默认提供以下数据卷定义：

```shell
 /srv/data			# 工作目录
 /srv/conf		    # 配置文件目录
```




## 使用方式

使用`--from=0`方式：

```dockerfile
# 预编译阶段 ===============================
FROM colovu/dbuilder

WORKDIR /tmp

# 相关下载/解压/编译操作

# ... 省略

# 镜像生成阶段 ==============================
FROM scratch
# 从编译阶段的中拷贝编译结果到当前镜像中(例如:编译的应用直接安装至/usr/local时)
COPY --from=0 /usr/local/ /usr/local

# ... 省略其它操作

# 镜像命令
CMD []
```

使用`--from=name`方式：

```dockerfile
# 预编译阶段。命名为`builder` ==================
FROM colovu/dbuilder as builder

WORKDIR /tmp

# 相关下载/解压/编译操作

# ... 省略

# 镜像生成阶段 ==============================
FROM scratch
# 从编译阶段的中拷贝编译结果到当前镜像中(例如:编译的应用直接安装至/usr/local时)
COPY --from=builder /usr/local/ /usr/local

# ... 省略其它操作

# 镜像命令
CMD []
```

使用该方式的优势：

- 因系统相关软件包已更新，工具已经预先安装，不需要在每次编译镜像时耗费大量时间在类似重复工作上
- 不用安装、删除临时软件，放置生成多余的垃圾文件；预编译阶段的内容使用完即丢弃，不会对镜像大小产生影响
- 没有相关的中间操作步骤,不会产生多余的镜像分层




----

本文原始来源 [Endial Fang](https://github.com/colovu) @ [Github.com](https://github.com)

