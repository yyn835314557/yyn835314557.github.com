---
layout: post
title: "Swift构造过程(Initialization)"
date: 2014-09-21
comments: true
categories: Swift
tags: [Swift Initialization] 
keywords: Swift 构造过程 
description: 2014-09-21-Swift构造过程(Initialization)
---

本文主要介绍Swift语言的中class、struct、enum的构造过程，构造器的定义。注意与析构过程进行比较

> 构造过程是为了使用某个类、结构体或枚举类型的实例而进行的准备过程。这个过程包含了为实例中的每个存储
型属性设置初始值和为其执行必要的准备和初始化任务。

> 构造过程是通过定义构造器( Initializers )来实现的,这些构造器可以看做是用来创建特定类型实例的特殊方 法。与 Objective-C 中的构造器不同,Swift 的构造器无需返回值,它们的主要任务是保证新实例在第一次使用 前完成正确的初始化。

###存储属性的初始赋值
类和结构体在实例创建时,必须为所有存储型属性设置合适的初始值。存储型属性的值不能处于一个未知的状态。

你可以在构造器中为存储型属性赋初值,也可以在定义属性时为其设置默认值

> 当你为存储型属性设置默认值或者在构造器中为其赋值时,它们的值是被直接设置的,不会触发任何属性观测器( property observers )。

- 默认属性值: 在构造器中为存储型属性设置初始值;同样,你也可以在属性声明时为其设置默认值

###自定义构造器

你可以通过输入参数和可选属性类型来定义构造过程,也可以在构造过程中修改常量属性。

*构造参数*

```Swift
struct Celsius{
    var temperatureCelsius:Double = 0.0
    init(fromFahrenheit fahrenheit:Double){
        temperatureCelsius = (fahrenheit - 32) / 1.8
    }
    init(fromKelvin kelvin:Double){
        temperatureCelsius = kelvin - 273.15
    }
}
let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
let freezingPointOfWater = Celsius(fromKelvin: 273.15)
```
*参数的内部名称与外部名称*

跟函数和方法参数相同,构造参数也存在一个在构造器内部使用的参数名字和一个在调用构造器时使用的外部参
数名字。Swift 会为每个构造器的参数自动生成一个跟内部名字相同的外部名,就相当于在每个构造参数之前加了一个 哈希符号。

```Swift
struct Color {
    let red, green, blue: Double
    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    init(white: Double) {
        red = white;
        green = white
        blue = white
    }
}
let magenta = Color(red: 1.0, green: 0, blue: 1.0)
let halfGray = Color(white: 0.5)
let white = Color(white: 1.0)
let black = Color(white: 0.0)
```

*不带外部名的构造器参数*

如果你不希望为构造器的某个参数提供外部名字,你可以使用下划线(_)来显示描述它的外部名,以此重写上面所 说的默认行为

```Swift
struct Celsius {
	var temperatureInCelsius: Double = 0.0 
	init(fromFahrenheit fahrenheit: Double) {
		temperatureInCelsius = (fahrenheit - 32.0) / 1.8 
	}
	init(fromKelvin kelvin: Double) { 
		temperatureInCelsius = kelvin - 273.15
	}
	init(_ celsius: Double){
		temperatureInCelsius = celsius 
	}
}
let bodyTemperature = Celsius(37.0)
// bodyTemperature.temperatureInCelsius 为 37.0
```

*可选属性类型*

如果你定制的类型包含一个逻辑上允许取值为空的存储型属性--不管是因为它无法在初始化时赋值,还是因为它 可以在之后某个时间点可以赋值为空--你都需要将它定义为可选类型 optional type 。可选类型的属性将自动初 始化为空 nil ,表示这个属性是故意在初始化时设置为空的。

```Swift
class SurveyQuestion { 
	var text: String
	var response: String? 
	init(text: String) {
		self.text = text 
	}
	func ask() { 
		print(text)
	} 
}
let cheeseQuestion = SurveyQuestion(text: "Do you like cheese?") cheeseQuestion.ask()
// 输出 "Do you like cheese?"
cheeseQuestion.response = "Yes, I do like cheese."
```

*构造过程中常量属性的修改*

只要在构造过程结束前常量的值能确定,你可以在构造过程中的任意时间点修改常量属性的值。

> 注意:
 对某个类实例来说,它的常量属性只能在定义它的类的构造过程中修改;不能在子类中修改。

*默认构造器*

Swift 将为所有属性已提供默认值的且自身没有定义任何构造器的结构体或基类,提供一个默认的构造器。这个默认构造器将简单的创建一个所有属性值都设置为默认值的实例。

```Swift
class ShoppingListItem { 
	var name: String?
	var quantity = 1
	var purchased = false
}
var item = ShoppingListItem()
```

*结构体的逐一成员构造器*

除上面提到的默认构造器,如果结构体对所有存储型属性提供了默认值且自身没有提供定制的构造器,它们能自动获得一个逐一成员构造器。

```Swift
struct Size {
 var width = 0.0 
 var height = 0.0
}
let twoByTwo = Size(width: 2.0, height: 2.0)
```

> Note:
 class必须赋初值或者设置为可选类型，无构造器自动产生无参数构造器；struct可以不赋初值,所有属性在实例化后必须有值(可选的自动赋值为nil),产生无值参数的逐一赋值的构造器。

*值类型的构造器代理*

构造器可以通过调用其它构造器来完成实例的部分构造过程。这一过程称为构造器代理,它能减少多个构造器间
的代码重复。

构造器代理的实现规则和形式在值类型和类类型中有所不同。值类型(结构体和枚举类型)不支持继承,所以构 造器代理的过程相对简单,因为它们只能代理给本身提供的其它构造器。类则不同,它可以继承自其它类,这意味着类有责任保证其所有继承的存储型属性在构造时也能正确的初始化
- 值类型(struct,enum): 它们只能代理给本身提供的其它构造器
	- `self.init`
	- 如果你为某个值类型定义了一个定制的构造器,你将无法访问到默认构造器(如果是结构体,则无法访问逐一对象构造器)。这个限制可以防止你在为值类型定义了一个更复杂的,完成了重要准备构造器之后,别人还是错误的使用了那个自动生成的构造器。

 > 假如你想通过默认构造器、逐一对象构造器以及你自己定制的构造器为值类型创建实例,建议你将自己定制的构造器写到扩展( extension )中,而不是跟值类型定义混在一起。

 ```Swift
 struct Size {
 	var width = 0.0, height = 0.0
 }
 struct Point {
 	var x = 0.0, y = 0.0 
 }
 struct Rect {
 	var origin = Point()
 	var size = Size()
	init() {}
	init(origin: Point, size: Size) {
	self.origin = origin
	self.size = size }
	init(center: Point, size: Size) {
 let originX = center.x - (size.width / 2)
 let originY = center.y - (size.height / 2) self.init(origin: Point(x: originX, y: originY), size: size)
} }
 ```