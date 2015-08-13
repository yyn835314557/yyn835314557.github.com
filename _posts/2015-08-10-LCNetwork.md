---
layout: post
title: "网络请求LCNetwork"
date: 2015-08-10
comments: true
categories: iOS AFNetworking
tags: [iOS, AFNetworking]
keywords: AFNetworking iOS
publish: true
description: 网络请求封装库
---
网络层的封装一直是项目中不足之处，前不久看了唐巧大神的[YTKNetwork](https://github.com/yuantiku/YTKNetwork)后又拜读了宇大神的这篇[博客](http://casatwy.com/iosying-yong-jia-gou-tan-wang-luo-ceng-she-ji-fang-an.html?utm_source=tuicool)，前者让我看到了离散型API封装的典型例子，后者恰好又提供了用 protocol 封装的很好思路以及说明了继承方式的封装的优缺点，于是结合两者 LCNetwork 就诞生了。

LCNetwork 主要功能有

* API类使用 protocol 约束，不用担心漏写方法
* 支持 block 和 delegate 的回调方式
* 支持设置主、副两个服务器地址
* 支持 response 缓存，基于 TMCache
* 支持统一的 argument 或 response 加工

###统一配置

{% highlight ruby %}
LCNetworkConfig *config = [LCNetworkConfig sharedInstance];
config.mainBaseUrl = ENCRYPTWEBAPI; // 设置主服务器地址
config.viceBaseUrl = WEBAPI; // 设置副服务器地址
config.logEnabled = YES;// 是否打印log信息
// 配置 argument 或 response 统一处理
LCProcessFilter *filter = [[LCProcessFilter alloc] init];
config.processRule = filter;
{% endhighlight %}


LCProcessFilter 这个类需要你自己实现，但必须遵守 LCProcessProtocol 协议，同时实现相关的方法，包括

{% highlight ruby %}
// 加工参数
- (NSDictionary *) processArgumentWithRequest:(NSDictionary *)argument;
// 加工response
- (id) processResponseWithRequest:(id)response;
{% endhighlight %}

参数加工：比较常见，比如添加版本号，添加加密参数等。response 加工：针对于 response 有统一格式的，比如：

{% highlight ruby %}
data = {

};
message = ok;
result = success;
{% endhighlight %}

我们关心的是大部分都是 data 中的数据，所以添加统一 response 加工后就不需要每次取出data中的数据再处理，我的处理是这样的：

{% highlight ruby %}
- (id) processResponseWithRequest:(id)response{
    if ([response[@"result"] isEqualToString:@"error"]) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: response[@"message"]};
        return [NSError errorWithDomain:ErrorDomain code:0 userInfo:userInfo];
    }
    else{
        return response[@"data"];
    }
}
{% endhighlight %}


###创建接口调用类

是的，每个接口调用都需要一个类去执行，这个类必须是 LCBaseRequest 子类，而且必须遵守 LCAPIRequest 协议，例如

{% highlight ruby %}
@interface Api1 : LCBaseRequest<LCAPIRequest>
// 参数属性
@synthesize requestArgument;
// 接口地址
- (NSString *)apiMethodName{
    return @"getweather.aspx";
}
// 请求方式
- (LCRequestMethod)requestMethod{
    return LCRequestMethodGet;
}
// 是否缓存数据，每次请求都会更新这个缓存
- (BOOL)withoutCache{
    return YES;
}
{% endhighlight %}

其他方法包括
{% highlight ruby %}
// 是否是副Url
@property (nonatomic, assign, getter = isViceUrl) BOOL viceUrl;
// 超时时间
- (NSTimeInterval) requestTimeoutInterval;
// 用于上传数据的block
- (AFConstructingBlock)constructingBodyBlock;
// response处理，用于进一步的数据处理
- (id)responseProcess;
{% endhighlight %}

如何调用

{% highlight ruby %}
Api2 *api2 = [[Api2 alloc] init];
api2.requestArgument = @{
                         @"lat" : @"34.345",
                         @"lng" : @"113.678"
                         };
[api2 startWithCompletionBlockWithSuccess:^(Api2 *api2) {
    self.weather2.text = api2.responseJSONObject[@"Weather"];
} failure:NULL];
{% endhighlight %}

另外对于HUD的显示和消失的处理方式和[YTKNetwork](https://github.com/yuantiku/YTKNetwork)是一样的，其他可以参考 [Demo](https://github.com/bawn/LCNetwork)，目前整个库并非不是很完善我会积极更新。
