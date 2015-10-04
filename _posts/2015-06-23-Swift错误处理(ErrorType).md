---
layout: post
title: "Swift错误处理(ErrorType)"
date: 2015-06-23
comments: true
categories: Swift
tags: [Swift] 
keywords: 错误处理 Swift
description: Swift错误处理(ErrorType)
---

本文主要介绍 Swift2.0 语言的新特性 --错误处理机制。错误处理是响应错误以及从错误中返回的过程。swift提供第一类错误支持,包括在运行时抛出,捕获,传送和控
制可回收错误。

一些函数和方法不能总保证能够执行所有代码或产生有用的输出。可空类型用来表示值可能为空,但是当函数执 行失败的事后,可空通常可以用来确定执行失败的原因,因此代码可以正确地响应失败。在Swift中,这叫做抛出 函数或者抛出方法。

 > Note: 
  Swift中的错误处理涉及到错误处理样式,这会用到Cocoa中的NSError和Objective-C。

***

*错误的表示:*
