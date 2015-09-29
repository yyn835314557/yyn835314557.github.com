---
layout: post
title: "iOS NSNotificationCenter 详解"
date: 2015-08-25
comments: true
categories: iOS
tags: [NSNotification]
keywords: 消息传输机制 
description: iOS NSNotificationCenter 详解
---

上文章篇介绍了iOS应用程序的RunTime与RunLoop，本篇主要介绍iOS开发中消息处理机制NSNotification。

上一篇：

[iOS开发中的RunLoop与RunTime](https://yyn835314557.github.io/ios/2015/08/20/iOS开发中的RunLoop,RunTime.html)


> 一个消息通知机制，类似广播。观察者只需要向消息中心注册感兴趣的东西，当有地方发出这个消息的时候，通知中心会发送给注册这个消息的对象。这样也起到了多个对象之间解耦的作用。苹果给我们封装了这个NSNotificationCenter，让我们可以很方便的进行通知的注册和移除。

```
class NSNotificationCenter : NSObject {
	// 拿到一个全局的通知中心
    class func defaultCenter() -> NSNotificationCenter

    // 将observer变为监听这个通知的对象, selector为收到通知时要调用的方法 aName 监听的通知的名称 anObject你要为你调用的方法传入的参数
    func addObserver(observer: AnyObject, selector aSelector: Selector, name aName: String?, object anObject: AnyObject?)
    
    // post一个通知,注册了监听的对象都会调用方法, 同理 下边的2个Post方法的操作是同样的传入的Object可以在监听者那里被收到。userInfo可用于传多个键值对。
    func postNotification(notification: NSNotification)
    func postNotificationName(aName: String, object anObject: AnyObject?)
    func postNotificationName(aName: String, object anObject: AnyObject?, userInfo aUserInfo: [NSObject : AnyObject]?)
    
    // remove 移除监听者， 与addObserver相对应
    func removeObserver(observer: AnyObject)
    func removeObserver(observer: AnyObject, name aName: String?, object anObject: AnyObject?)
    
    // AddObserverForName, Block ， 使用线程, 通知名称, 对象, Block来监听通知, 就是把1中的方法调用变为了Block。
    @available(OSX 10.6, *)
    func addObserverForName(name: String?, object obj: AnyObject?, queue: NSOperationQueue?, usingBlock block: (NSNotification) -> Void) -> NSObjectProtocol
}
```

```
/****************	Notifications	****************/
class NSNotification : NSObject, NSCopying, NSCoding {
    
    var name: String { get }
    var object: AnyObject? { get }
    var userInfo: [NSObject : AnyObject]? { get }
    
    @available(OSX 10.6, *)
    init(name: String, object: AnyObject?, userInfo: [NSObject : AnyObject]?)
    init?(coder aDecoder: NSCoder)
}

extension NSNotification {
    
    convenience init(name aName: String, object anObject: AnyObject?)
    
    convenience init() /*NS_UNAVAILABLE*/ /* do not invoke; not a valid initializer for this class */
}
```

***

下一篇:

[UIViewController的生命周期及iOS程序执行顺序.md](https://yyn835314557.github.io/ios/2015/08/30/UIViewController的生命周期及iOS程序执行顺序.html)