# 使用官方的Ubuntu基础镜像
FROM ubuntu:20.04

LABEL maintainer="hujinbo23 jinbohu23@outlook.com"
LABEL description="DoNotStarveTogehter server panel written in golang.  github: https://github.com/hujinbo23/dst-admin-go"

# 修正最大文件描述符数，部分docker版本给的默认值过高，会导致screen运行卡顿
# This fixes the slow startup issue mentioned in issue #80
RUN echo "* soft nofile 65536" >> /etc/security/limits.conf && \
    echo "* hard nofile 65536" >> /etc/security/limits.conf

# 更新并安装必要的软件包
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
    curl \
    libcurl4-gnutls-dev:i386 \
    lib32gcc1 \
    lib32stdc++6 \
    libcurl4-gnutls-dev \
    libgcc1 \
    libstdc++6 \
    wget \
    ca-certificates \
    screen \
    procps \
    sudo \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# 安装 Go 以构建应用程序
RUN apt-get update && \
    apt-get install -y wget tar && \
    wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz && \
    rm go1.21.0.linux-amd64.tar.gz

# 设置 Go 环境变量
ENV PATH=$PATH:/usr/local/go/bin
ENV GOROOT=/usr/local/go

# 设置工作目录
WORKDIR /app

# 拷贝源代码
COPY . /app

# 构建应用程序
RUN go mod tidy && \
    go build -o dst-admin-go .

# 设置权限
RUN chmod 755 /app/dst-admin-go
RUN chmod 755 /app/docker-entrypoint.sh

# 创建必要的目录结构
RUN mkdir -p /app/steamcmd \
    && mkdir -p /app/dst-dedicated-server \
    && mkdir -p /root/.klei/DoNotStarveTogether \
    && mkdir -p /app/backup \
    && mkdir -p /app/mod

# 拷贝配置文件
COPY config.yml /app/config.yml
COPY docker_dst_config /app/dst_config
COPY static /app/static

# 创建API-only模式所需的目录结构
# 为兼容性创建空的dist目录（即使不使用前端）
RUN mkdir -p /app/dist/assets /app/dist/static/js /app/dist/static/css /app/dist/static/img /app/dist/static/fonts /app/dist/static/media

# 设置默认环境变量
ENV STEAMCMD_PATH=/app/steamcmd
ENV DST_SERVER_PATH=/app/dst-dedicated-server

# 内嵌源配置信息
# 控制面板访问的端口
EXPOSE 8082/tcp
# 饥荒世界通信的端口
EXPOSE 10888/udp
# 饥荒洞穴世界的端口
EXPOSE 10998/udp
# 饥荒森林世界的端口
EXPOSE 10999/udp

# 设置工作目录
WORKDIR /app

# 运行命令
ENTRYPOINT ["./docker-entrypoint.sh"]
