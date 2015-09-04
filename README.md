##BGNetwork是什么？
BGNetwork是一个基于**AFNetworking**封装的一个网络框架，它主要由**BGNetworkManager**、**BGNetworkRequest**、**BGNetworkConnector**、**BGNetworkCache**、**BGNetworkConfiguration**五个部分组成。它的工作流程是将每个网络请求封装一个Request对象，然后交给BGNetworkManager发送请求，最后使用统一的代理方法调回。


##如何使用？

1.1 子类化一个BGNetworkConfiguration类，实现BGNetworkConfiguration协议从对网络进行配置，在Appdelegate.m文件中将它设置给BGNetworkManager。   
```objective-c
[[BGNetworkManager sharedManager] setNetworkConfiguration:[DemoNetworkConfiguration configuration]];
```

2.2 根据业务子类化BGNetowrkRequest封装请求，实现BGNetowrkRequest协议，然后发送请求。   
```objective-c
    DemoRequest *request = [[DemoRequest alloc] initPage:_page pageSize:_pageSize];
    [request sendRequestWithDelegate:self];
```

##有哪些功能？
* 支持统一设置baseURL
* 支持对网络请求的数据进行缓存以及配置不同的读取缓存策略
* 支持统一的delegate方法调回
* 提供公共业务参数的配置
* 提供HTTP请求头的配置
* 提供对请求数据的加密入口

##Podfile
```ruby
 platform :ios, '7.0'
 pod "BGNetwork", "~> 0.1.1"
 ```


##相关类的任务角色
<p align="center" >
  <img src="https://raw.githubusercontent.com/chunguiLiu/BGNetwork/master/assets/architecture.png" alt="AFNetworking" title="AFNetworking" height=251 width = 556>
</p>
