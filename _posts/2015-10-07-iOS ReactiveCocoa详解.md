---
layout: post
title: "2015-10-07-iOS ReactiveCocoa详解"
date: 2015-10-07
comments: true
categories: iOS
tags: [ReactiveCocoa]
keywords: RAC  
description: iOS ReactiveCocoa详解
---

上文章篇介绍了iOS应用程序的RunTime与RunLoop，本篇主要介绍iOS开发中消息处理机制NSNotification。

上一篇：

[2015-09-13-iOS中MVVM介绍(Model-View-ViewModel)](https://yyn835314557.github.io/ios/2015/09/13/i2015-09-13-iOS中MVVM介绍(Model-View-ViewModel).html)

参考资料:
	(http://www.raywenderlich.com/62699/reactivecocoa-tutorial-pt1)
	(https://github.com/ReactiveCocoa/ReactiveCocoa/blob/master/Documentation/FrameworkOverview.md)
	(http://www.jianshu.com/p/87ef6720a096#)


#### 概述:

 ReactiveCocoa 是一个重型的 FRP(Functional Reactive Programming 是一种响应变化的编程范式)框架，内容十分丰富，它使用了大量内建的block，这使得其有强大的功能的同时，内部源码也比较复杂

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

#### RAC核心类介绍

 You can see that each time you change the text within the text field, the code within the block executes. No target-action, no delegates — just signals and blocks

 > As mentioned in the introduction, ReactiveCocoa provides a standard interface for handling the disparate stream of events that occur within your application. In ReactiveCocoa terminology these are called signals, and are represented by the RACSignal class.

 RACSignal 传递事件流给 subscribers 。事件的类型可以分为3种: next、error、completed。signal会传递一个任意的数字给下一个事件，在事件error 或者completed之前
