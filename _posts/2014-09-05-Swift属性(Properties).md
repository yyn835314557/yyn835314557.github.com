---
layout: post
title: "Swift属性(Properties)"
date: 2014-09-05
comments: true
categories: Swift
tags: [Swift Properties] 
keywords: Swift属性
description: Swift属性(Properties)
---

本文主要介绍Swift语言的属性的基本概念，包含计算属性、存储属性、类型属性、属性观察者、全局与局部变量

> 
1. 属性将值跟特定的类、结构或枚举关联。存储属性存储常量或变量作为实例的一部分,而计算属性计算(不是存
储)一个值。计算属性可以用于类、结构体和枚举,存储属性只能用于类和结构体。
2. 存储属性和计算属性通常与特定类型的实例关联。但是,属性也可以直接作用于类型本身,这种属性称为类型属性。
3. 还可以定义属性观察器来监控属性值的变化,以此来触发一个自定义的操作。属性观察器可以添加到自己
定义的存储属性上,也可以添加到从父类继承的属性上。

- 存储属性: 只存在于类与结构体中
	- 存储属性可以是变量存储属性,也可以是常量存储属性。可以在定义存储属性的时候指定默认值,也可以在构造过程中设置或修改存储属
	性的值,甚至修改常量存储属性的值(只要在构造过程结束前常量的值能确定,你可以在构造过程中的任意时间点修改常量属性的值;对某个类实例来说,它的常量属性只能在定义它的类的构造过程中修改;不能在子类中修改。)。
	- 常量存储属性
		- 若为结构体实例(值类型)，值类型实例声明为常量，所有属性也变为常量，即使定义了变量存储属
		性，也无法修改实例的任何属性
		- 若为类实例(引用类型)，把一个引用类型的实例赋给一个常量后,仍然可以修改该实例的变量属 性。
	- 延迟存储属性(lazy): 延迟存储属性是指当第一次被调用的时候才会计算其初始值的属性
		- 必须将延迟存储属性声明成变量(使用 var 关键字),因为属性的初始值可能在实例构造完成之后才会得 到。而常量属性在构造过程完成之前必须要有初始值,因此无法声明成延迟属性。
		- `lazy var lazyAttribute = Class()`

		> 注意:
		 如果一个被标记为 lazy 的属性在没有初始化时就同时被多个线程访问,则无法保证该属性只会被初始化一次。(多次初始化缺点？)

	- 存储属性和实例变量
		- 如果您有过 Objective-C 经验,应该知道 Objective-C 为类实例存储值和引用提供两种方法。对于属性来说,也可以使用实例变量作为属性值的后端存储。
		Swift 编程语言中把这些理论统一用属性来实现。Swift 中的属性没有对应的实例变量,属性的后端存储也无法直 接访问。这就避免了不同场景下访问方式的困扰,同时也将属性的定义简化成一个语句。一个类型中属性的全部 信息——包括命名、类型和内存管理特征——都在唯一一个地方(类型定义中)定义。

- 计算属性(var 声明): 存在于类结构体与枚举类型中,计算属性不直接存储值,而是提供一个 getter 和一个可选 的 setter,来间接获取和设置其他属性或变量的值。
	- 只读计算属性: 只有getter，总是返回一个值，可以通过点运算符访 问,但不能设置新的值。
- 属性观察者: 
	- 监控和响应属性值的变化,每次属性被设置值的时候都会调用属性观察器,甚至新的值和现在的值相同的时候也不例外。
	- 可以为除了延迟存储属性之外的其他存储属性添加属性观察器,也可以通过重载属性的方式为继承的属性(包括 存储属性和计算属性)添加属性观察器。
	- 不需要为非重载的计算属性添加属性观察器,因为可以通过它的setter直接监控和响应值的变化。
	- 可以为属性添加如下的一个或者全部的观察器:
		- willSet: 在新值被设置之前调用(newValue)
			- 观察器会将新的属性值作为常量参数传入,在 willSet 的实现代码中可以为这个参数指定一个名称,如果
			不指定则参数仍然可用,这时使用默认名称 newValue 表示。
		- didSet: 在新值设置之后立即被调用（之前的值为oldValue）
			- didSet 观察器会将旧的属性值作为参数传入,可以为该参数命名或者使用默认参数名 oldValue 。
			- 如果在一个属性的didSet观察器里为它赋值,这个值会替换该观察器之前设置的值(很重要)。
- 全局变量与局部变量: 计算属性和属性观察器所描述的模式也可以用于全局变量和局部变量
	- 全局变量是在函数、方法、闭包或任何类型之外定义的变量。局部变量是在函数、方法或闭包内部定义的变量。
	- 全局的常量或变量都是延迟计算的,跟延迟存储属性相似,不同的地方在于,全局的常量或变量不需要标记lazy特性。局部范围的常量或变量不会延迟计算。
- 实例属性:
	- 实例的属性属于一个特定类型实例,每次类型实例化后都拥有自己的一套属性值,实例之间的属性相互独立。
- 类型属性: `static var variable: Int = 0` 必须赋初值，没有使用构造方法 
	- 也可以为类型本身定义属性,不管类型有多少个实例,这些属性都只有唯一一份。这种属性就是类型属性。
	- 类型属性用于定义特定类型所有实例共享的数据,比如所有实例都能用的一个常量(就像C语言中的静态常量),或者所有实例都能访问的一个变量(就像 C 语言中的静态变量)。
	- 跟实例的存储属性不同,必须给存储型类型属性指定默认值,因为类型本身无法在初始化过程中使用构造器给类型属性赋值
	- 使用关键字 static 来定义类型属性。在为类(class)定义计算型类型属性时,可以使用关键字 class 来支持子 类对父类的实现进行重写
	- 跟实例的属性一样,类型属性的访问也是通过点运算符来进行。但是,类型属性是通过类型本身来获取和设置,而不是通过实例。

 > 在 C 或 Objective-C 中,与某个类型关联的静态常量和静态变量,是作为全局(global)静态变量定义的。但 是在 Swift 编程语言中,类型属性是作为类型定义的一部分写在类型最外层的花括号内,因此它的作用范围也就 在类型支持的范围内。

 ```Swift
struct AudioChannel{
    static let thresholdLevel = 10
    static var maxInputLevelForAllChannels = 0
    var currentLevel: Int = 0 {
        didSet {
            if (currentLevel > AudioChannel.thresholdLevel ){
                    // 将新电平值设置为阀值
                currentLevel = AudioChannel.thresholdLevel
        }
            if (currentLevel > AudioChannel.maxInputLevelForAllChannels ) {
                    // 存储当前电平值作为新的最大输入电平
                AudioChannel.maxInputLevelForAllChannels = currentLevel
            }
        }
    }
}

var leftChannel = AudioChannel()
var rightChannel = AudioChannel()
//如果将左声道的电平设置成 7,类型属性 maxInputLevelForAllChannels 也会更新成 7:
leftChannel.currentLevel = 7;
print(leftChannel.currentLevel)
// 输出 "7" print(AudioChannel.maxInputLevelForAllChannels) // 输出 "7"
//如果试图将右声道的电平设置成 11,则会将右声道的 currentLevel 修正到最大值 10,同时 llChannels 的值也会更新到 10:maxInputLevelForA
rightChannel.currentLevel = 11;
print(rightChannel.currentLevel)// 输出 "10"
print(AudioChannel.maxInputLevelForAllChannels) // 输出 "10"
 ```
