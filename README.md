[![Build Status](https://travis-ci.org/liuchungui/BGNetwork.svg?branch=dev)](https://travis-ci.org/liuchungui/BGNetwork)
[![codecov.io](https://codecov.io/github/liuchungui/BGNetwork/coverage.svg?branch=dev)](https://codecov.io/github/liuchungui/BGNetwork?branch=dev)

##BGNetwork是什么？
BGNetwork是一个基于**AFNetworking**封装的一个网络框架，它主要由**BGNetworkManager**、**BGNetworkRequest**、**BGNetworkConfiguration**、**BGNetworkCache**组成。它的工作流程是先将每个网络请求封装成一个Request对象，然后交给BGNetworkManager发送请求，最后使用block调用回来。

##有哪些功能？
* 支持统一设置baseURL
* 提供对url的queryString部分进行配置
* 提供对HTTP请求头的配置
* 提供对HTTP请求体的配置，并可进行加密
* 支持对网络请求的数据进行缓存以及配置不同的缓存策略
* 提供对Response解密的配置
* 扩展了批量发送请求和串行发送请求
* 提供成功、业务失败、网络失败三种block回调

##类的介绍
####BGNetworkRequest
网络请求类，当发起一个网络请求的时候，需要子类化这个类。BGNetworkRequest提供了跟业务相关的设置，例如设置是GET请求还是POST请求、请求的方法名、请求的业务参数、缓存策略、请求头等等。当需要发起一个请求时，使用sendRequestWithSuccess:businessFailure:networkFailure:发起请求，使用cancelRequest类方法取消请求。

####BGNetworkConfiguration
这是一个整个网络的配置类，它提供的功能有：

* 配置baseURL
* 对BGNetworkRequest进行预处理
* 对请求统一设置请求头
* 对请求设置query string
* 组装POST请求的请求体
* 对Response进行解密
* 配置对某个请求是否缓存
* 配置当前的请求是业务成功，减少业务层的判断


####BGNetworkManager
它是一个单例，协调着BGRequest、BGNetworkCache和BGNetworkConfiguration三者进行工作。

####BGNetworkCache
一个以写文件的形式进行缓存的类。


##如何使用？

首先，子类化一个BGNetworkConfiguration类，实现BGNetworkConfiguration协议，对网络进行配置，在Appdelegate.m文件中将它设置给BGNetworkManager。   
```objective-c
[[BGNetworkManager sharedManager] setNetworkConfiguration:[DemoNetworkConfiguration configuration]];
```

其次，根据业务子类化BGNetowrkRequest封装请求，然后发送请求。   

```objective-c
    DemoRequest *request = [[DemoRequest alloc] initPage:_page pageSize:_pageSize];
    [request sendRequestWithSuccess:^(BGNetworkRequest *request, id response) {
        [self request:request successWithResponse:response];
    } businessFailure:^(BGNetworkRequest *request, id response) {
        [self request:request businessFailureWithResponse:response];
    } networkFailure:^(BGNetworkRequest *request, NSError *error) {
        [self request:request failureWithNetworkError:error];
    }];
```

##Podfile
```
 platform :ios, '7.0'
 pod "BGNetwork"
 ```


##相关类的任务角色
<p align="center" >
  <img src="https://raw.githubusercontent.com/chunguiLiu/BGNetwork/master/assets/architecture.png" alt="BGNetwork" title="BGNetwork" height=251 width = 556>
</p>
