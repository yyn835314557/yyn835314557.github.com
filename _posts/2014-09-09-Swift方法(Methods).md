---
layout: post
title: "Swift方法(Methods)"
date: 2014-09-09
comments: true
categories: Swift
tags: [Swift Methods] 
keywords: Swift方法
description: Swift方法(Methods)
---

本文主要介绍Swift语言中的方法使用，主要包含实例方法和类型方法两部分

> 结构体和枚举能够定义方法是Swift与C/Objective-C的主要区别之一。在 Objective-C 中,类是唯一能定义 方法的类型。但在 Swift 中,你不仅能选择是否要定义一个类/结构体/枚举,还能灵活的在你创建的类型(类/结 构体/枚举)上定义方法。类型方法与 Objecti ve-C 中的类方法(class methods)相似。

- ###实例方法(Instance Methods)
	-  实例方法是属于某个特定类、结构体或者枚举类型实例的方法。实例方法提供访问和修改实例属性的方法或提供与实例目的相关的功能,并以此来支撑实例的功能。实例方法的语法与函数完全一致,详情参见函数。
	- 方法的局部参数名称和外部参数名称
	- 修改方法的外部参数名称(#,_)
	- self属性: 类型的每一个实例都有一个隐含属性叫做self,self完全等同于该实例本身。你可以在一个实例的实例方法中 使用这个隐含的self属性来引用当前实例。区别属性与参数
	- 在实例方法中修改值类型(mutating func): 一般来说值类型属性不能在实例方法中被修改，struct
	- 在变异方法中给self赋值
- ###类型方法(Type Methods): class struct enum,Objective-C只有class
	- 定义类型本身调用的方法,这种方法就叫做类型方法。声明 结构体和枚举的类型方法,在方法的 func 关键字之前加上关键字 static 。类可能会用关键字 Class 来允许子类 重写父类的实现方法。
	- 在类型方法的方法体(body)中, self 指向这个类型本身,而不是类型的某个实例。对于结构体和枚举来 说,这意味着你可以用 self 来消除静态属性和静态方法参数之间的歧义(类似于我们在前面处理实例属性和实例 方法参数时做的那样)。
	- 一般来说,任何未限定的方法和属性名称,将会来自于本类中另外的类型级别的方法和属性。一个类型方法可以调用本类中另一个类型方法的名称,而无需在方法名称前面加上类型名称的前缀。同样,结构体和枚举的类型方法也能够直接通过静态属性的名称访问静态属性,而不需要类型名称前缀。

```Swift
struct LevelTracker {
    static var highestUnlockedLevel = 1
    static func unlockLevel(level: Int) {
        if level > highestUnlockedLevel { highestUnlockedLevel = level }
    }
    static func levelIsUnlocked(level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }
    var currentLevel = 1
    mutating func advanceToLevel(level: Int) -> Bool {
        if LevelTracker.levelIsUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}

class Player {
        var tracker = LevelTracker()
        let playerName: String
        func completedLevel(level: Int) {
            LevelTracker.unlockLevel(level + 1)
            tracker.advanceToLevel(level + 1)
        }
        init(name: String) {
            playerName = name
        }
}

var player = Player(name: "Argyrios")
player.completedLevel(1)
print("highest unlocked level is now \(LevelTracker.highestUnlockedLevel)")
// 打印输出:highest unlocked level is now 2

player = Player(name: "Beto")
if player.tracker.advanceToLevel(6) {
            print("player is now on level 6") } else {
            print("level 6 has not yet been unlocked") }
// 打印输出:level 6 has not yet been unlocked
```