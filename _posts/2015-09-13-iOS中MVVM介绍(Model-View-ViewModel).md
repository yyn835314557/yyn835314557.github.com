---
layout: post
title: "MVVM介绍(Model-View-ViewModel)"
date: 2015-09-13
comments: true
categories: iOS
tags: [框架, iOS]
keywords: 软件框架 iOS
description: 关于MVVM框架
---

Swift中使用KVC和KVO的类都必须必须继承自NSObject

***

## KVC(key-value coding: 键值编码):

> 是1种间接访问对象的机制,key的值就是属性名称的字符串，返回的value是任意类型，需要自己转化为需要的类型

KVC主要就是两个方法:
（1）通过key设置对应的属性;
（2）通过key获得对应的属性;


##KVO (Key-Value Observing: 键值监听):

> KVO(Key-Value Observing: 键值监听):建立在KVC之上的的机制,主要功能是检测对象属性的变化,和属性观察不同，KVO的目的并不是为当前类的属性提供一个钩子方法，而是为了其他不同实例对当前的某个属性 (严格来说是 keypath) 进行监听时使用的。其他实例可以充当一个订阅者的角色，当被监听的属性发生变化时，订阅者将得到通知。这是1个完善的机制，不需要用户自己设计复杂的视察者模式,对需要视察的属性要在前面加上dynamic关键字

- 这是一个很强大的属性，通过 KVO 我们可以实现很多松耦合的结构，使代码更加灵活和强大：像通过监听 model 的值来自动更新 UI 的绑定这样的工作，基本都是基于 KVO 来完成的
- 在 Swift 中我们也是可以使用 KVO 的，但是仅限于在 NSObject 的子类中。这是可以理解的，因为 KVO 是基于 KVC (Key-Value Coding) 以及动态派发技术实现的，而这些东西都是 Objective-C 运行时的概念。另外由于 Swift 为了效率，默认禁用了动态派发，因此想用 Swift 来实现 KVO，我们还需要做额外的工作，那就是将想要观测的对象标记为 dynamic。
- Swift中使用KVO有两个问题:
  	- 对属性要有dynamic修饰(用dynamic修饰要损失部分性能)，若无法修改类的源码，只能继承这个类并且将需要观察的属性使用 dynamic 进行重写在子类中简单地用 super 去调用父类里相关的属性就可以了
  	- 对于那些非 NSObject 的 Swift 类型怎么办。因为 Swift 类型并没有通过 KVC 进行实现，所以更不用谈什么对属性进行 KVO 了。对于 Swift 类型，语言中现在暂时还没有原生的类似 KVO 的观察机制。我们可能只能通过属性观察来实现一套自己的类似替代了。结合泛型和闭包这些 Swift 的先进特性 (当然是相对于 Objective-C 来说的先进特性)，把 API 做得比原来的 KVO 更优雅其实不是一件难事。Observable-Swift 就利用了这个思路实现了一套对 Swift 类型进行观察的机制。





