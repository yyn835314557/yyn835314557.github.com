---
layout: post
title: "Swift继承(Inheritance)"
date: 2014-10-03
comments: true
categories: Swift
tags: [Swift Inheritance] 
keywords: Swift 继承
description: Swift继承(Inheritance)
---

本文主要介绍Swift语言中类的继承，主要包含基类的定义、子类生成及重写

> 一个类可以继承(inherit)另一个类的方法(methods),属性(properties)和其它特性。当一个类继承其它 类时,继承类叫子类(subclass),被继承类叫超类(或父类,superclass)。类可以调用和访问超类的方法,属性和下标脚本(subscripts),并且可以重写(override)这些 方法,属性和下标脚本来优化或修改它们的行为。Swift 会检查你的重写定义在超类中是否有匹配的定义,以此确 保你的重写行为是正确的。

## 在Swift中,继承是区分类与其它类型的一个基本特征。

> 可以为类中继承来的属性添加属性观察器(property observers),这样一来,当属性值改变时,类就会被通知到。可以为任何属性添加属性观察器,无论它原本被定义为存储型属性(stored property)还是计算型属性(co mputed property)。

## 只有存储属性才能设置属性观察者，而继承属性除外

- 基类(Base class)的定义: 不继承于其它类的类,称之为基类

> Swift 中的类并不是从一个通用的基类继承而来。如果你不为你定义的类指定一个超类的话,这个类就自动成为基类。

 ```Swift
 class Vehicle{
 	var currentSpeed = 0.0
 	var description:String{
 		return "Travelling at \(currentSpeed) miles per hour"
 	}
 	func makeNoise(){
 		// Nothing to do
 	}
 }
 let someVehicle = Vehicle()
 print("Vehicle:\(someVehicle.description)")
 ```

- 子类的生成(Subclassing):

 ```Swift
 class Bicycle:Vehicle{
 	var hasBasket = false
 }
 let bicycle = Bicycle()
 bicycle.hasBasket = true
 bicycle.currentSpeed = 15.0
 print("Bycycle:\(bicycle.description)")
 class Tandem:Bicycle{
 	var currentNumberOfPassengers = 0
 }
 let tandem = Tandem()
 tandem.hasBasket = true 
 tandem.currentNumberOfPassengers = 2 
 tandem.currentSpeed = 22.0 
 print("Tandem: \(tandem.description)")
 // Tandem: traveling at 22.0 miles per hour
 ```

- 重写(Overriding): 

>Note:
你不可以为继承来的常量存储型属性或继承来的只读计算型属性添加属性观察器。这些属性的值是不可以被设置 的,所以,为它们提供 willSet 或 didSet 实现是不恰当。此外还要注意,你不可以同时提供重写的 setter 和重 写的属性观察器。如果你想观察属性值的变化,并且你已经为那个属性提供了定制的 setter,那么你在 setter 中就可以观察到任何值变化了。

	- 定义: 子类可以为继承来的实例方法(instance method),类方法(class method),实例属性(instance proper ty),或下标脚本(subscript)提供自己定制的实现(implementation)。我们把这种行为叫重写(overridin g)。
	- 访问超类的方法,属性及下标脚本;使用 super 前缀来访问超类版本的方法,属性或下标脚本
		- 在方法 someMethod 的重写实现中,可以通过 super.someMethod() 来调用超类版本的 someMethod 方法。
		- 在属性 someProperty 的 getter 或 setter 的重写实现中,可以通过 super.someProperty 来访问超类版本的 someProperty 属性。
		- 在下标脚本的重写实现中,可以通过 super[someIndex] 来访问超类版本中的相同下标脚本。
	- 重写方法
		```Swift
		 class Train: Vehicle {
			override func makeNoise() {
				print("Choo Choo") 
			}
		 }
		 let train = Train() train.makeNoise()
		 // prints "Choo Choo"
		```
	- 重写属性: 你可以重写继承来的实例属性或类属性,提供自己定制的getter和setter,或添加属性观察器使重写的属性可以观 察属性值什么时候发生改变。
	 	- 重写属性的Getters和Setters
	 	 ```Swift
	 	 class Car: Vehicle {
			var gear = 1
			override var description: String {
			return super.description + " in gear \(gear)" 
			}
		 }
		 let car = Car()
		 car.currentSpeed = 25.0
		 car.gear = 3
		 print("Car: \(car.description)")
		 // Car: traveling at 25.0 miles per hour in gear 3
	 	 ```
	 	- 重写属性观察器(Property Observer)
	 	```Swift
	 	 class AutomaticCar: Car {
			override var currentSpeed: Double {
			didSet {
			gear = Int(currentSpeed / 10.0) + 1 
				}
			} 
		 }
		 let automatic = AutomaticCar()
		 automatic.currentSpeed = 35.0
		 print("AutomaticCar: \(automatic.description)")
		 // AutomaticCar: traveling at 35.0 miles per hour in gear 4
	 	```

		> 你可以提供定制的 getter(或 setter)来重写任意继承来的属性,无论继承来的属性是存储型的还是计算型的属 性。子类并不知道继承来的属性是存储型的还是计算型的它只知道继承来的属性会有一个名字和类型。你在重 写一个属性时,必需将它的名字和类型都写出来。这样才能使编译器去检查你重写的属性是与超类中同名同类型 的属性相匹配的。你可以将一个继承来的只读属性重写为一个读写属性,只需要你在重写版本的属性里提供 getter 和 setter 即 可。但是,你不可以将一个继承来的读写属性重写为一个只读属性。

	- 防止重写:
		- 你可以通过把方法,属性或下标脚本标记为 final 来防止它们被重写,只需要在声明关键字前加上 final 特性即可。(例如: final var , final func , final class func , 以及 final subscript )
		- 如果你重写了 final 方法,属性或下标脚本,在编译时会报错。在类扩展中的方法,属性或下标脚本也可以在扩展的定义里标记为 final。
		- 你可以通过在关键字 class 前添加 final 特性( final class )来将整个类标记为 final 的,这样的类是不可被继承 的,任何子类试图继承此类时,在编译时会报错。
