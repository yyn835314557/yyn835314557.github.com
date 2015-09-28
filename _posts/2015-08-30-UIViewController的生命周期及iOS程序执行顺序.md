---
layout: post
title: "UIViewController的生命周期及iOS程序执行顺序"
date: 2015-08-30
comments: true
categories: iOS
tags: [UIViewController]
keywords: 视图控机制 
description: UIViewController的生命周期及iOS程序执行顺序
---

上文章篇介绍了iOS应用程序的消息处理机制，本篇主要介绍iOS开发中的视图控制器的生命周期，这是iOS开发中的重点。

上一篇：

[iOS NSNotificationCenter 详解](/_posts/2015-08-25-iOS NSNotificationCenter 详解.md)
#UIViewController的生命周期及iOS程序执行顺序

> A页面 -> B页面:
  - A viewDidLoad
  - A viewWillAppear
  - A viewDidAppear
  - B viewDidLoad
  - A viewWillDisappear
  - B viewWillAppear
  - A viewDidDispaaear
  - B viewDidiAppear
 B -> A
  - B viewWillDisappear
  - A viewWillAppear
  - B viewDidDisappear
  - A viewDidAppear
 一般Avc跳转到Bvc，正常情况下Bvc返回Avc的时候是不调用A的viewdidload的，是因为Avc这个对象还存在内存中，它的view以及subviews也都还存在内存中，所以系统没有执行A的loadview方法，也就没有执行A的viewdidload方法。那么有时候情况是这样的，Avc跳转到了Bvc，这时候出现了设备内存不足的警告， 也就是viewController会收到didReceiveMemoryWarning的消息。系统会默认释放掉不在当前使用的view hierarchy的视图，也就是Avc的view及其subview被释放了。那么Bvc返回到Avc的时候就，Avc首先要调用loadview去创建一个有效的view,在调用viewdidload来进行其他subview的初始化。 
 

- 当一个视图控制器被创建，并在屏幕上面显示的时候，代码的执行顺序:
 1. alloc	
 2. init(initWithNibName)
 3. loadView
 4. viewDidLoad
 5. viewwillAppear
 6. viewDidAppear

- 当一个视图被移除屏幕并且销毁的时候，执行顺序相反:
 1. viewWillDisappear
 2. viewDidDispatch
 3. dealloc
 
- UIViewController类对象方法，(后四种有动画，返回值Bool类型)
	- viewDidLoad
	- viewDidUnload
	- viewWillAppear
	- viewDidAppear
	- viewWillDisappear
	- viewDidDisappear

- APP在运行时的调用顺序
	1. viewDidLoad
		 - 我们对于各种初始数据的载入，初始设定等很多内容，都会在这个方法中实现
		 - 个方法只会在APP刚开始加载的时候调用一次，以后都不会再调用它了，所以只能用来做初始设置。
	2. viewDidUnload
		 - 在内存足够的情况下，软件的视图通常会一直保存在内存中，但是如果内存不够，一些没有正在显示的viewcontroller就会收到内存不够的警告，然后就会释放自己拥有的视图，以达到释放内存的目的。但是系统只会释放内存，并不会释放对象的所有权，所以通常我们需要在这里将不需要在内存中保留的对象释放所有权，也就是将其指针置为nil。
		 - 这个方法通常并不会在视图变换的时候被调用，而只会在系统退出或者收到内存警告的时候才会被调用。但是由于我们需要保证在收到内存警告的时候能够对其作出反应，所以这个方法通常我们都需要去实现
		 - 即使在设备上按了Home键之后，系统也不一定会调用这个方法
	3. viewWillAppear(非常常用)
		 - 系统在载入所有数据后，将会在屏幕上显示视图，这时会先调用这个方法。通常我们会利用这个方法，对即将显示的视图做进一步的设置。例如，我们可以利用这个方法来设置设备不同方向时该如何显示。
		 - 当APP有多个视图时，在视图间切换时，并不会再次载入viewDidLoad方法，所以如果在调入视图时，需要对数据做更新，就只能在这个方法内实现了。
	4. viewDidAppear
		 -  有时候，由于一些特殊的原因，我们不能在viewWillApper方法里，对视图进行更新。那么可以重写这个方法，在这里对正在显示的视图进行进一步的设置
	5. viewWillDisappear
		 - 视图即将移除，覆盖，调用这个方法进行善后处理和设置
		 - 系统允许将APP在后台挂起，所以在按了Home键之后，系统并不会调用这个方法，因为就这个APP本身而言，APP显示的view，仍是挂起时候的view，所以并不会调用这个方法
	6. viewDidDispear
		 - 对已经消失，覆盖，隐藏的视图做操作

 > 运行APP —> 载入视图 —> 调用viewDidLoad方法 —> 调用viewWillAppear方法 —> 调用viewDidAppear方法 —>   正常运行 

- IOS 开发 loadView 和 viewDidLoad 的区别
	- viewDidload只有当view从nib文件初始化的时候才被调用
	- loadView 在控制器的view为nil的时候被调用。 此方法用于以编程的方式创建view的时候用到

 > 你在控制器中实现了loadView方法，那么你可能会在应用运行的某个时候被内存管理控制调用;
 	设备内存不足的时候， view 控制器会收到didReceiveMemoryWarning的消息;
 	默认的实现是检查当前控制器的view是否在使用。如果它的view不在当前正在使用的view hierarchy里面，且你的控制器实现了loadView方法，那么这个view将被release, loadView方法将被再次调用来创建一个新的view。
 	系统会在内存不足时调用viewDidUnload，再次展示该页面时，还会调用viewDidLoad

***
