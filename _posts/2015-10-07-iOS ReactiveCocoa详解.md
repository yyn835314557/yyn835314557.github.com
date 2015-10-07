---
layout: post
title: "2015-10-07-iOS ReactiveCocoa详解"
date: 2015-10-07
comments: true
categories: iOS
tags: [ReactiveCocoa]
keywords: 消息传输机制 
description: iOS ReactiveCocoa详解
---

上文章篇介绍了iOS应用程序的RunTime与RunLoop，本篇主要介绍iOS开发中消息处理机制NSNotification。

上一篇：

[iOS开发中的RunLoop与RunTime](https://yyn835314557.github.io/ios/2015/08/20/iOS开发中的RunLoop,RunTime.html)

参考资料:
	(http://www.raywenderlich.com/62699/reactivecocoa-tutorial-pt1)
	(https://github.com/ReactiveCocoa/ReactiveCocoa/blob/master/Documentation/FrameworkOverview.md)


#### 概述:

 ReactiveCocoa 是一个重型的 FRP(Functional Reactive Programming 是一种响应变化的编程范式)框架，内容十分丰富，它使用了大量内建的block，这使得其有强大的功能的同时，内部源码也比较复杂

 - Functional Programming
 - Reactive Programming

 > As an iOS developer, nearly every line of code you write is in reaction to some event; a button tap, a received network message, a property change (via Key Value Observing) or a change in user’s location via CoreLocation are all good examples. However, these events are all encoded in different ways; as actions, delegates, KVO, callbacks and others. ReactiveCocoa defines a standard interface for events, so they can be more easily chained, filtered and composed using a basic set of tools.
	
#### 