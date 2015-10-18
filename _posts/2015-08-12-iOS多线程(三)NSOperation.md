---
layout: post
title: "iOS 多线程 (三) NSOperation"
date: 2015-08-12
comments: true
categories: iOS
tags: [NSOperation] 
keywords: NSOperation iOS多线程
description: iOS多线程(三)NSOperation
---

上两文章篇介绍了NSThread以及GCD的使用，本篇介绍iOS多线程编程中的最后一种方法NSOperation。

上一篇：
[iOS多线程(二)GCD](https://yyn835314557.github.io/ios/2015-08-10-iOS多线程(二)GCD.html)


> NSOperation是苹果封装的一套多线程的东西，不像GCD是纯C语言的，这个是OC的。但相比较之下GCD会更快一些，但本质上NSOPeration是多GDC的封装。

####NSOperation相对于GCD：
 - NSOperation拥有更多的函数可用
 - NSOperationQueue中，可以建立各个NSOperation之间的依赖关系。
 - NSOperationQueue支持KVO。可以监测operation是否正在执行（isExecuted）、是否结束（isFinished），是否取消（isCanceld）
 - GCD只支持FIFO的队列，而NSOperationQueue可以调整队列的执行顺序

##NSOperation剖析:

> NSOperation是个抽象类，并不具备封装操作的能力，必须使用它的子类

####使用NSOperation子类的方式有3种:
 - NSInvocationOperation
 - NSBlockOperation
 - 自定义子类继承NSOperation，实现内部相应的方法

####NSOperationQueue
 1. NSOperation可以调用start方法来执行任务，但默认是同步执行的
 2. 如果将NSOperation添加到NSOperationQueue（操作队列）中，系统会自动异步执行NSOperation中的操作
 ```
 // 添加操作到NSOperationQueue中
- (void)addOperation:(NSOperation *)op;
- (void)addOperationWithBlock:(void (^)(void))block;
 ```


##NSOperation的使用:

配合使用NSOperation和NSOperationQueue就能实现多线程编程:
 1. 将需要执行的操作封装到一个NSOperation对象中
 2. 将NSOperation对象添加到NSOperationQueue中
 3. 系统会自动将NSOperationQueue中的NSOperation取出来放到一条新线程中执行


 - NSInvocationOperation子类
 - NSBlockOperation子类
 - 自定义NSOperation


##NSOperation方法

 1. 最大并发数

 > 可以通过对最大并发数设置，控制程序中线程的数量

 2. 取消、暂停、恢复

 3. 依赖

 4. 操作的监听

 ***


### NSOperation 和 GCD 的比较

 GCD是基于c的底层api，NSOperation属于OC类。ios首先引入的是NSOperation，IOS4之后引入了GCD和NSOperationQueue并且其内部是用gcd实现的。

 相对于GCD：

 1. NSOperation拥有更多的函数可用，具体查看api。
 2. NSOperationQueue中，可以建立各个NSOperation之间的依赖关系。
 3. 有kvo，可以监测operation是否正在执行（isExecuted）、是否结束（isFinished），是否取消（isCanceld）。
 4. NSOperationQueue可以方便的管理并发、NSOperation之间的优先级。

 GCD主要与block结合使用。代码简洁高效。

 GCD也可以实现复杂的多线程应用，主要是建立个个线程时间的依赖关系这类的情况，但是需要自己实现相比NSOperation要复杂。
 具体使用哪个，依需求而定。 从个人使用的感觉来看，比较合适的用法是：除了依赖关系尽量使用GCD，因为苹果专门为GCD做了性能上面的优化。


下一篇:

[iOS应用程序生命周期(前后台切换，应用的各种状态)详解](https://yyn835314557.github.io/ios/2015-08-15-iOS应用程序生命周期(前后台切换，应用的各种状态)详解.html)