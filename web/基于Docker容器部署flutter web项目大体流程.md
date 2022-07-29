## 基于Docker容器部署flutter web项目大体流程

#### 一、安装flutter SDK
```
# dockerfile写法事例
# 下载解压Flutter SDK
RUN ["/bin/bash", "-c", "wget -O /opt/data0/soft/flutter-2.10.3.zip https://storage.flutter-io.cn/flutter_infra_release/releases/stable/linux/flutter_linux_2.10.3-stable.tar.xz"]
RUN ["/bin/bash", "-c", "cd /opt/data0/soft && unzip flutter-2.10.3.zip"]
# 定义系统环境变量
ENV Flutter_home /opt/data0/soft/flutter-2.10.3
ENV PATH $PATH:$Flutter_home/bin
ENV FLUTTER_HOME=/opt/data0/soft/flutter \
    FLUTTER_ROOT=$FLUTTER_HOME \
    FLUTTER_VERSION=v2.10.3-stable \
    PUB_HOSTED_URL=https://pub.flutter-io.cn \
    FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
# 使flutter支持web
RUN flutter doctor
RUN flutter config --enable-web
```

#### 二、安装nginx
```
# dockerfile写法事例
RUN useradd -M -s /sbin/nologin nginx
RUN mkdir -p /usr/local/nginx/conf/vhost
RUN mkdir -p /data/logs/nginx
RUN yum -y install readline-devel pcre-devel openssl-devel gcc \
    telnet wget curl make && \
    yum clean all
RUN wget http://nginx.org/download/nginx-1.14.2.tar.gz && \
    tar zxf nginx-1.14.2.tar.gz && \
    cd nginx-1.14.2 && \
    ./configure --prefix=/usr/local/nginx \
    --with-http_ssl_module \
    --with-http_stub_status_module && \
    make -j 1 && make install && \
    rm -rf /usr/local/nginx/html/* && \
    cd / && rm -rf nginx-1.14.2* && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# 定义系统环境变量
ENV PATH /usr/local/nginx/sbin:$PATH
EXPOSE 80
```

#### 三、使用git拉取flutter web项目
```
# dockerfile写法事例
RUN mkdir -p /opt/project/flutter_web_project
RUN git clone git@igit.xxx.com:xxx/web/xxx.git -b develop /opt/project/flutter_web_project
```

#### 四、编译flutter web项目
```
# dockerfile写法事例
RUN cd /opt/project/flutter_web_project/ && flutter pub get && flutter build web
```

#### 五、运行flutter web项目
```
# dockerfile写法事例
# 复制flutter web项目编译后的build目录下所有文件到nginx配置的加载web工程路径下
RUN cp -r /opt/project/flutter_web_project/build/web/. /usr/local/nginx/html/
# 开启nginx服务器启动web项目
RUN cd /usr/local/nginx/sbin && nginx -g "daemon off;"
```