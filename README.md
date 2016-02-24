[![Build Status](https://travis-ci.org/liuchungui/BGNetwork.svg?branch=dev)](https://travis-ci.org/liuchungui/BGNetwork)
[![codecov.io](https://codecov.io/github/liuchungui/BGNetwork/coverage.svg?branch=dev)](https://codecov.io/github/liuchungui/BGNetwork?branch=dev)

##BGNetwork是什么？
BGNetwork是一个基于**AFNetworking**封装的一个网络框架，它主要由**BGNetworkManager**、**BGNetworkRequest**、**BGNetworkConfiguration**、**BGNetworkConnector**、**BGNetworkCache**五个部分组成。它的工作流程是先将每个网络请求封装成一个Request对象，然后交给BGNetworkManager发送请求，最后使用block调用回来。其中，在发送请求的过程中，有一个非常重要的类——BGNetworkConfiguration，这个类担任统一的配置，如baseURL、请求头的组建、请求体组建与加密、Response的解密。而我们的核心目标是只需要子类化一个BGNetworkConfiguration对整个网络框架进行配置，不需要改动任何源代码，就能快速满足业务需求。



##如何使用？

首先，子类化一个BGNetworkConfiguration类，实现BGNetworkConfiguration协议从对网络进行配置，在Appdelegate.m文件中将它设置给BGNetworkManager。   
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
####BGNetworkManager
它是一个单例，管理着BGNetworkConnector、BGNetworkCache和BGNetworkConfiguration三个对象。    
当一个请求BGNetworkRequest过来时，它会根据请求的缓存策略来决定是否读取缓存，而实现缓存的对象就是BGNetworkCache。当缓存策略是BGNetworkRquestCacheNone时，它不读取缓存，直接请求网络；当缓存策略是BGNetworkRequestCacheDataAndReadCacheOnly时，如果读取到缓存数据直接回调并且不再请求网络；当缓存策略是BGNetworkRequestCacheDataAndReadCacheLoadData时，它会读取缓存回调并且还会重新请求网络。

之后当发送网络请求时，它会通过BGNetworkConnector发送GET或POST请求，同时通过BGNetworkConfiguration来对url的queryString部分、请求头、请求体进行配置。
最后，当网络请求回来，它会通过BGNetworkConfiguration来解密回来的ResponseData，随后json解析化，然后根据BGNetworkConfiguration来确定是否缓存和此网络请求是否业务成功，然后走成功回调或业务失败回调。    

BGNetworkManager内部创建了一个工作串行队列和一个数据处理的并行队列。当一个请求过来时，它首先会将它所有工作跳入工作队列当中，而当需要解析数据时，它会放入数据处理队列进行处理。

####BGNetworkRequest
它是一个请求体，内部可以设置请求方法名、请求方式GET/POST、请求头、业务参数。



##Podfile
```
 platform :ios, '7.0'
 pod "BGNetwork"
 ```


##相关类的任务角色
<p align="center" >
  <img src="https://raw.githubusercontent.com/chunguiLiu/BGNetwork/master/assets/architecture.png" alt="AFNetworking" title="AFNetworking" height=251 width = 556>
</p>
