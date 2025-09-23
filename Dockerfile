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
    bash \
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

# 安装 Go 以构建应用程序到 /opt 目录避免与卷挂载冲突
RUN apt-get update && \
    apt-get install -y wget tar && \
    wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz && \
    mkdir -p /opt/go && \
    tar -C /opt/go -xzf go1.21.0.linux-amd64.tar.gz && \
    rm go1.21.0.linux-amd64.tar.gz

# 设置 Go 环境变量
ENV PATH=$PATH:/opt/go/go/bin
ENV GOROOT=/opt/go/go

# 使用完全独立的目录避免与任何可能的卷挂载冲突
WORKDIR /service

# 拷贝 entrypoint 脚本到根目录
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 拷贝源代码到 /service
COPY . /service

# 确保 entrypoint 脚本权限正确
RUN chmod +x /service/docker-entrypoint.sh

# 构建应用程序
RUN cd /service && go mod tidy && go build -o dst-admin-go

# 设置二进制文件权限
RUN chmod 755 /service/dst-admin-go

# 创建必要的数据目录（使用 /data 避免冲突）
RUN mkdir -p /data/steamcmd \
    && mkdir -p /data/dst-dedicated-server \
    && mkdir -p /data/saves \
    && mkdir -p /data/backup \
    && mkdir -p /data/mod

# 创建API-only模式所需的目录结构
RUN mkdir -p /service/dist/assets /service/dist/static/js /service/dist/static/css /service/dist/static/img /service/dist/static/fonts /service/dist/static/media

# 设置环境变量
ENV STEAMCMD_PATH=/data/steamcmd
ENV DST_SERVER_PATH=/data/dst-dedicated-server
ENV SAVES_PATH=/data/saves

# 端口配置
EXPOSE 8082/tcp
EXPOSE 10888/udp
EXPOSE 10998/udp
EXPOSE 10999/udp

# 使用根目录的标准 entrypoint 路径避免冲突
ENTRYPOINT ["/entrypoint.sh"]
