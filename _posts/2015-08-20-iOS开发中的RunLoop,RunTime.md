---
layout: post
title: "iOS开发中的RunLoop,RunTime"
date: 2015-08-20
comments: true
categories: iOS
tags: [RunLoop] [RunTime]
keywords: 运行机制 
description: iOS开发中的RunLoop,RunTime
---

上文章篇介绍了iOS应用程序的生命周期，本篇主要介绍iOS开发中的RunLoop与RunTime。

上一篇：

[iOS应用程序生命周期(前后台切换，应用的各种状态)详解](/_posts/2015-08-15-iOS应用程序生命周期(前后台切换，应用的各种状态)详解.md)


- OC调用函数机制
	- 函数调用称之为消息的分发，编译的时候不需要查找要执行的函数，必须要等到真正运行的时候，程序才查找要执行的函数。
	- 对于C语言，函数调用是由编译器直接转化完成的，在编译时程序就开始查找要执行的函数(C语言函数调用原理)。

 > 在C语言中，仅申明一个函数，不去实现。其他地方调用此函数。编译时就会报错(C语言编译时查找要执行的函数，找不到所以报错)。而同样的情况在OC中并不会报错，只有在运行时候才会报错。(OC运行时才查找要执行的函数)

- OC函数调用的底层实现(让程序拥有运行时特性)
	- Objective-C之所以能做到运行时才查找要执行的函数主要归功于runTime的SDK。
	- objc_msgSend(id self,SEL op,...),方法实现了函数查找和匹配

1. RunTime:
	- runtime是一套比较底层的纯C语言API, 属于1个C语言库, 包含了很多底层的C语言API。在我们平时编写的OC代码中, 程序运行过程时, 其实最终都是转成了runtime的C语言代码, runtime算是OC的幕后工作者

	- runtime是属于OC的底层, 可以进行一些非常底层的操作(用OC是无法现实的, 不好实现)
		- 在程序运行过程中, 动态创建一个类(比如KVO的底层实现)
		- 在程序运行过程中, 动态地为某个类添加属性\方法, 修改属性值\方法
		- 遍历一个类的所有成员变量(属性)\所有方法 
			- 例如：我们需要对一个类的属性进行归档解档的时候属性特别的多，这时候，我们就会写很多对应的代码，但是如果使用了runtime就可以动态设置！ 

	- 简称运行时,就是系统在运行的时候的一些机制，其中最主要的是消息机制。对于C语言，函数的调用在编译的时候会决定调用哪个函数（ C语言的函数调用请看这里 ）。编译完成之后直接顺序执行，无任何二义性。OC的函数调用成为消息发送。属于动态调用过程。在编译的时候并不能决定真正调用哪个函数（事实证明，在编 译阶段，OC可以调用任何函数，即使这个函数并未实现，只要申明过就不会报错。而C语言在编译阶段就会报错）。只有在真正运行的时候才会根据函数的名称找 到对应的函数来调用。

	- 举例说明：比如你[obj makeText]；则运行时就这样的：首先，编译器将代码[obj makeText];转化为objc_msgSend(obj, @selector (makeText));，在objc_msgSend函数中。首先通过obj的isa指针找到obj对应的class。在Class中先去cache中,通过SEL查找对应函数method（猜测cache中method列表是以SEL为key通过hash表来存储的，这样能提高函数查找速度），若 cache中未找到。再去methodList中查找，若methodlist中未找到，则取superClass中查找。若能找到，则将method加 入到cache中，以方便下次查找，并通过method中的函数指针跳转到对应的函数中去执行。

2. RunLoop
	- 概念：
		- EventLoop模型: 让线程能随时处理事件但并不退出，管理时间/消息，没有处理消息时休眠避免占用资源，有消息是立刻被唤醒。
		 	- Node.js的时间处理
		 	- Windows程序的消息循环
		 	- OSX/iOS里面的RunLoop
		- RunLoop 实际上就是一个对象，这个对象管理了其需要处理的事件和消息，并提供了一个入口函数来执行上面 Event Loop 的逻辑。线程执行了这个函数后，就会一直处于这个函数内部 "接受消息->等待->处理" 的循环中，直到这个循环结束（比如传入 quit 的消息），函数返回。
			- CFRunLoopRef
				- CoreFoundation框架，提供纯C函数的API，线程安全。
			- NSRunLoop
				- 基于CFRunLoopRef的封装，提供了面向对象的API，但是这些API不是线程安全的

	- RunLoop与线程的关系:
		- iOS 开发中能遇到两个线程对象: pthread_t 和 NSThread。你可以通过 pthread_main_np() 或 [NSThread mainThread] 来获取主线程；也可以通过 pthread_self() 或 [NSThread currentThread] 来获取当前线程。
		- CFRunLoop是基于pthread来管理的。
		- 苹果不允许直接创建RunLoop，它只提供了两个自动获取的函数：CFRunLoopGetMain() 和 CFRunLoopGetCurrent()。
		- 线程和 RunLoop 之间是一一对应的，其关系是保存在一个全局的 Dictionary 里。线程刚创建时并没有 RunLoop，如果你不主动获取，那它一直都不会有。RunLoop 的创建是发生在第一次获取时，RunLoop 的销毁是发生在线程结束时。你只能在一个线程的内部获取其 RunLoop（主线程除外）。

	- RunLoop对外接口: CoreFoundation里面关于RunLoop有五个类
		- CFRunLoopRef
		- CFRunLoopModelRef: CFRunLoopModeRef类并没有对外暴露，只是通过 CFRunLoopRef 的接口进行了封装
		- CFRunLoopSourceRef: 事件产生的地方，分为Source0和Source1两个版本
			- Source0 只包含了一个回调（函数指针），它并不能主动触发事件。使用时，你需要先调用 CFRunLoopSourceSignal(source)，将这个 Source 标记为待处理，然后手动调用 CFRunLoopWakeUp(runloop) 来唤醒 RunLoop，让其处理这个事件。
			- Source1 包含了一个 mach_port 和一个回调（函数指针），被用于通过内核和其他线程相互发送消息。这种 Source 能主动唤醒 RunLoop 的线程，其原理在下面会讲到。
		- CFRunLoopTimerRef
			- 基于时间的触发器，它和 NSTimer 是toll-free bridged 的，可以混用。其包含一个时间长度和一个回调（函数指针）。当其加入到 RunLoop 时，RunLoop会注册对应的时间点，当时间点到时，RunLoop会被唤醒以执行那个回调。
		- CFRunLoopObserverRef
			- 是观察者，每个 Observer都包含了一个回调（函数指针），当RunLoop的状态发生变化时，观察者就能通过回调接受到这个变化。可以观测的时间点有以下几个：
				- kCFRunLoopEntry         = (1UL << 0), // 即将进入Loop
				- kCFRunLoopBeforeTimers  = (1UL << 1), // 即将处理 Timer
				- kCFRunLoopBeforeSources = (1UL << 2), // 即将处理 Source
				- kCFRunLoopBeforeWaiting = (1UL << 5), // 即将进入休眠
				- kCFRunLoopAfterWaiting  = (1UL << 6), // 刚从休眠中唤醒
				- kCFRunLoopExit          = (1UL << 7), // 即将退出Loop
		- 上面的 Source/Timer/Observer 被统称为 mode item，一个 item 可以被同时加入多个 mode。但一个 item 被重复加入同一个 mode 时是不会有效果的。如果一个 mode 中一个 item 都没有，则 RunLoop 会直接退出，不进入循环

		> 一个 RunLoop 包含若干个 Mode，每个 Mode 又包含若干个 Source/Timer/Observer。每次调用 RunLoop 的主函数时，只能指定其中一个 Mode，这个Mode被称作 CurrentMode。如果需要切换 Mode，只能退出 Loop，再重新指定一个 Mode 进入。这样做主要是为了分隔开不同组的 Source/Timer/Observer，让其互不影响。

	- RunLoop的Mode


***

下一篇:

[iOS NSNotificationCenter 详解.md](/_posts/2015-08-25-iOS NSNotificationCenter 详解.md)