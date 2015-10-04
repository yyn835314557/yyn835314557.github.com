---
layout: post
title: "Swift析构过程(Deinitialization)"
date: 2014-10-25
comments: true
categories: Swift
tags: [Swift Deinitialization] 
keywords: Swift 析构过程 
description: 2014-10-25-Swift析构过程(Deinitialization)
---

上一篇介绍了Swift语言class、struct、enum的构造过程，本篇中主要介绍Swift语言的析构过程，主要包含析构过程的原理以及析构器的操作,析构器只适用于类类型，当一个类的实例被释放之前,析构器会被立即调用。析构器用关键字 deinit 来标示,类似于构造器要用 init 来标示。

###析构过程原理

Swift 会自动释放不再需要的实例以释放资源(ARC对实例进行内存管理)，但是,当使用自己的资源时,你可能 需要进行一些额外的清理。例如,如果创建了一个自定义的类来打开一个文件,并写入一些数据,你可能需要在 类实例被释放之前手动去关闭该文件。

 > 在类的定义中,每个类最多只能有一个析构器,而且析构器不带任何参数
  `deinit{//执行操作}`

析构器是在实例释放发生前被自动调用。析构器是不允许被主动调用的。子类继承了父类的析构器,并且在子类析构器实现的最后,父类的析构器会被自动调用。即使子类没有提供自己的析构器,父类的析构器也同样会被调用。

因为直到实例的析构器被调用时,实例才会被释放,所以析构器可以访问所有请求实例的属性,并且根据那些属性可以修改它的行为(比如查找一个需要被关闭的文件)。

###析构器操作

 ```Swift
 struct Bank{
    static var coinsInBank = 10_000
    static func vendCoins(var numberOfCoinsToVend:Int) ->Int{
        numberOfCoinsToVend = min(numberOfCoinsToVend, coinsInBank)
        coinsInBank -= numberOfCoinsToVend
        return numberOfCoinsToVend
    }
    static func receiveCoins(coins:Int){
        coinsInBank += coins
    }
}

class Player {
    var coinsInPurse: Int
    init(coins: Int) {
        coinsInPurse = Bank.vendCoins(coins)
    }
    func winCoins(coins: Int) {
        coinsInPurse += Bank.vendCoins(coins)
    }
    deinit {
        Bank.receiveCoins(coinsInPurse)
    }
}

// 这里使用一个可选变量,是因为玩家可以随时离开游戏。设置 为可选使得你可以跟踪当前是否有玩家在游戏中。
var playerOne: Player? = Player(coins: 100)
print("A new player has joined the game with \(playerOne!.coinsInPurse) coins")
// 输出 "A new player has joined the game with 100 coins"
print("There are now \(Bank.coinsInBank) coins left in the bank")
// 输出 "There are now 9900 coins left in the bank"

playerOne!.winCoins(2_000)
print("PlayerOne won 2000 coins & now has \(playerOne!.coinsInPurse) coins")
// 输出 "PlayerOne won 2000 coins & now has 2100 coins"
print("The bank now only has \(Bank.coinsInBank) coins left")
// 输出 "The bank now only has 7900 coins left"


// 当这种情况发生的时候, ￼ 变量对 ￼ 实例的引用被破坏了。没有其它属性或者变量引用实例,因此为了清空它占用的内存从而释放它。在这发生前,其析构器会被自动调用,从而使其硬币被返回 到bank对象中。
playerOne = nil
print("PlayerOne has left the game")
// 输出 "PlayerOne has left the game"
print("The bank now has \(Bank.coinsInBank) coins")
// 输出 "The bank now has 10000 coins"
 ```
