---
layout: post
title: "iOS ReactiveCocoa详解"
date: 2015-10-07
comments: true
categories: iOS
tags: [ReactiveCocoa]
keywords: RAC Framework 
description: iOS ReactiveCocoa详解
---

上篇文章介绍了iOS开发中的MVVM开发框架，这篇中我们将主要介绍iOS开发中很流行的RactiveCocoa框架，同时也学习一下 Objective-C 语言。

上一篇：

[2015-09-13-iOS中MVVM介绍(Model-View-ViewModel)](https://yyn835314557.github.io/ios/2015/09/13/i2015-09-13-iOS中MVVM介绍(Model-View-ViewModel).html)

参考资料:

(http://www.raywenderlich.com/62699/reactivecocoa-tutorial-pt1)
(https://github.com/ReactiveCocoa/ReactiveCocoa/blob/master/Documentation/FrameworkOverview.md)
(http://www.jianshu.com/p/87ef6720a096#)
(http://nathanli.cn/2015/08/27/reactivecocoa2-%E6%BA%90%E7%A0%81%E6%B5%85%E6%9E%90/)


#### 概述:

 ReactiveCocoa 是一个重型的 FRP (Functional Reactive Programming 是一种响应变化的编程范式) 框架，内容十分丰富，它使用了大量内建的block，这使得其有强大的功能的同时，内部源码也比较复杂

 RAC统一了对KVO、UI Event、Network request、Async work的处理，因为它们本质上都是值的变化(Values over time)。以用来监测属性的改变，这点跟KVO很像，不过使用了block，而不是 `-observeValueForKeyPath:ofObject:change:context:`;比KVO更加强大的是信号可以被链起来(chain)

 - Functional Programming
 - Reactive Programming

 > As an iOS developer, nearly every line of code you write is in reaction to some event; a button tap, a received network message, a property change (via Key Value Observing) or a change in user’s location via CoreLocation are all good examples. However, these events are all encoded in different ways; as actions, delegates, KVO, callbacks and others. ReactiveCocoa defines a standard interface for events, so they can be more easily chained, filtered and composed using a basic set of tools.
	
 FRP的核心是信号，信号在ReactiveCocoa(以下简称RAC)中是通过RACSignal来表示的，信号是数据流，可以被绑定和传递。

 主要的编程思想

 - 面向过程: C
 - 面向对象: C++ 、Java等大部分语言
 - 链式编程思想: 多个操作通过链接成为一句代码。 fun1(para1).fun2(para2).fun2(para3)
	 - 特点: 返回值为闭包，闭包参数不为空，必须有返回值
	 - eg: Masonry框架


 ![图片一](/images/ReactiveCocoa/RAC1.png)


#### RAC系统机制:

 You can see that each time you change the text within the text field, the code within the block executes. No target-action, no delegates — just signals and blocks

 > As mentioned in the introduction, ReactiveCocoa provides a standard interface for handling the disparate stream of events that occur within your application. In ReactiveCocoa terminology these are called signals, and are represented by the RACSignal class.

 RACSignal 传递事件流给 subscribers 。事件的类型可以分为3种: next、error、completed。signal在事件error 或者completed之前,会传递一个任意的数字给下一个事件。

 subscribeNext 提供一个block用来支持执行的的每一个 next 事件。

 RAC框架使用 categories 给许多标准UIKit控件添加signal，以便我们能向这些控件的事件添加subscriptions，rac_textSignal就是从这些event中传来的。


#### RAC核心类介绍:

 你可以使用种类繁多的operators去操控事件流(eg: filter operator, map operator, combineLatest:reduce)

 each operation on an RACSignal also returns an RACSignal it’s termed a fluent interface. This feature allows you to construct pipelines without the need to reference each step using a local variable.

 > 在Objective-C 中，id 类型是一个独特的数据类型。在概念上，类似Java 的Object 类，可以转换为任何数据类型。换句话说，id 类型的变量可以存放任何数据类型的对象。在内部处理上，这种类型被定义为指向对象的指针，实际上是一个指向这种对象的实例变量的指针

 RAC 的宏有两个参数；一个是 the property to set；第二个 property name;

 下面是这两个简单的pipelines的视图：

 ![图片二](/images/ReactiveCocoa/RAC2.png)

 ReactiveCocoa has a cunning little utility class, RACBlockTrampoline that handles the reduce block’s variable argument list internally. In fact, there are a lot of cunning tricks hidden within the ReactiveCocoa implementation, so it’s well worth pulling back the covers!

 This is one of the key differences you’ll find when you adopt a reactive style — you don’t need to use instance variables to track transient state.


#### RACPassthroughSubscriber(订阅者装饰器)

 订阅者每一次订阅信号是产生一个 Disposable ，并将其与此次订阅关联起来，通过装饰器 RACPassthroughSubscriber 来做到，装饰器的功能如下:

 	 - 包装真正的订阅者，使自己成为订阅者的替代者
 	 - 将真正的订阅者与一个订阅时产生的 Disposable 关联起来。
 	 

#### RACDynamicSignal(自定义信号) 的订阅方法 subscribe

 RACDynamicSignal 使用 RACPassthroughSubscriber ,订阅者装饰器直接伪装成真正的订阅器，传给 didSubscribe 这个 block 使用。在这个 block 中，会有一些事件发送给订阅者装饰器，而这个订阅者装饰器则根据 disposable 的状态来来决定是否转发给真正的订阅者。disposable 作为返回值，返回给外部，也就是说能够从外部来取消这个订阅了。
