## 基于Docker容器部署dart服务端项目大体流程

#### 一、安装Dart SDK
```
# dockerfile写法事例
# 下载解压Dart SDK
RUN ["/bin/bash", "-c", "wget -O /opt/data0/soft/dart-2.1.1.zip https://storage.flutter-io.cn/dart-archive/channels/stable/release/2.1.1/sdk/dartsdk-linux-x64-release.zip"]
RUN ["/bin/bash", "-c", "cd /opt/data0/soft && unzip dart-2.1.1.zip"]
# 定义系统环境变量
ENV DART_HOME /opt/data0/soft/dart-2.1.1
ENV PATH $PATH:$DART_HOME/bin
```

#### 二、使用git拉取dart服务端项目
```
# dockerfile写法事例
RUN mkdir -p /opt/project/dart_server_project
RUN git clone git@igit.xxx.com:xxx/server/xxx.git -b develop /opt/project/dart_server_project
```

#### 三、编译dart服务端项目
```
# dockerfile写法事例
RUN cd /opt/project/dart_server_project && dart pub get
RUN dart compile exe /opt/project/dart_server_project/bin/server.dart -o /opt/project/dart_server_project/server
```

#### 四、运行dart服务端项目
```
# dockerfile写法事例
./opt/project/dart_server_project/server
```