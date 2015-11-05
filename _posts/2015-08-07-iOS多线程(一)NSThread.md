---
layout: post
title: "iOS 多线程 (一) NSThread"
date: 2015-08-07
comments: true
categories: iOS
tags: [NSThread]
keywords: NSThread iOS多线程
description: iOS多线程(一)NSThread
---

本文主要介绍iOS多线程中的NSThread，此为面试常问问题。

上一篇：
[iOS多线程总结](https://yyn835314557.github.io/ios/2015-07-25-iOS多线程总结.html)

> 一个NSThread对象控制执行的线程。当你想在自己的执行线程的Objective-C的方法运行使用这个类。当你需要执行一个漫长的任务线程是特别有用的，但不希望它阻止应用程序的其余部分的执行。特别是，您可以使用线程来避免阻塞应用程序，它处理的用户界面和事件相关的操作的主线。线程也可以用来将一个大的工作分成几个较小的作业，这可能会导致在多核计算机性能的提高。

- 创建和启动线程
     - 优点：简单快捷
     - 缺点：无法对线程进行更详细的设置

![NSThread](/images/multithread/NSThreadCode.png)

- 主线程相关用法
    ```
    // 返回主线程
    + (NSThread *)mainThread;
    // 是否为主线程(类方法)
    + (BOOL)isMainThread; 
    // 是否为主线程（对象方法）
    - (BOOL)isMainThread;
    ```
- 其他方法
    ```
    // 线程通知
    NSDidBecomeSingleThreadedNotification
    NSThreadWillExitNotification 
    NSWillBecomeMultiThreadedNotification

    // 获得当前线程
    NSThread *current = [NSThread currentThread];
    // 线程的名字
    - (void)setName:(NSString *)n; 
    - (NSString *)name;
    ```

***

## 线程的状态
```
// 进入就绪状态 -> 运行状态。当线程任务执行完毕，自动进入死亡状态
- (void)start;
// 阻塞（暂停）线程->进入阻塞状态
+ (void)sleepUntilDate:(NSDate *)date;
+ (void)sleepForTimeInterval:(NSTimeInterval)ti;
// 强制停止线程-> 进入死亡状态
+ (void)exit;

//注意：一旦线程停止（死亡）了，就不能再次开启任务
```
 ![Thread state](/images/multithread/state.png)

## 多线程的安全隐患 

> 一块资源可能会被多个线程共享，也就是多个线程可能会访问同一块资源。
当多个线程访问同一块资源时，很容易引发数据错乱和数据安全问题。

解决办法：（互斥锁）
    - 优势:能有效防止因多线程抢夺资源
    - 缺点:需要消耗大量的CPU资源

atomic与nonatomic

> OC在定义属性时有nonatomic和atomic两种选择

`@property (nonatomic, copy)NSString *name;@property (atomic, copy)NSString *name;`

- atomic：原子属性，为setter方法加锁（默认就是atomic）
- 线程安全，需要消耗大量的资源

- nonatomic: 非原子属性，不会为setter方法加锁
- 非线程安全，适合内存小的移动设备

开发建议

> 1. 所有属性都声明为nonatomic
  2. 尽量避免多线程抢夺同一块资源
  3. 尽量将加锁、资源抢夺的业务逻辑交给服务器端处理，减小移动客户端的压力


## 线程间通信

> 在1个进程中，线程往往不是孤立存在的，多个线程之间需要经常进行通信,例如在子线程下载图片，在主线程刷新UI显示图片。

```
// 1.在主线程上执行操作
- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait;
// 2.在指定线程上执行操作
- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(id)arg waitUntilDone:(BOOL)wait;
```

***

下一篇:

[多线程(二)GCD](https://yyn835314557.github.io/ios/2015-08-10-iOS多线程(二)GCD.html)