---
layout: post
title: "Swift新特性选项集合(OptionSet)详解"
date: 2015-06-18
comments: true
categories: Swift
tags: [Swift OptionSet] 
keywords: Swift OptionSet
description: 2015-06-18-Swift新特性选项集合(OptionSet)详解
---

本篇中主要介绍Swift 2.0语言的新特性 -- Option Set,详细介绍其基本概念及代码示例。


- 位掩码
	- 在写一个角色扮演的游戏（比如说传奇）游戏的角色可能拥有各种装备，比如盔甲，剑以及头盔等等。定义一个整数并使用它的比特位来进行表示。由于每个比特位只能存储 0 或者 1，可以使用它来对每个装备进行表示，这就是所谓的位掩码。

- 位掩码的操作:

 ```Swift
	struct Inventory: OptionSetType {
    let rawValue: Int
    static let Sword = Inventory(rawValue: 1)
    static let Armor = Inventory(rawValue: 1 << 1)
    static let Helmet = Inventory(rawValue: 1 << 2)
	}

	var inventory: Inventory = [.Sword, .Shield]
	if inventory.contains(.Shield) {
    	print("屠龙在手，天下我有")
	}	
 ```


#####示例代码

 ```
	import Foundation

	struct Skills: OptionSetType {
	    let rawValue:Int
	    static let LOL = Skills(rawValue: 1)
	    static let GitHub = Skills(rawValue: 1<<1)
	    static let Personal = Skills(rawValue: 1<<2)
	    static let StackOverflow = Skills(rawValue: 1<<3)
	}

	struct Programmer {
	    var possibleSkills:Skills = [.LOL]
	    /**
	    由于要在方法里修改结构体中的属性，所以都得加上 mutating 修饰符。三个方法里都使用了 Set 集合的方法来对程序员的技能进行改变。
	    */
	    mutating func quitLOL(){
	        if possibleSkills.contains(.LOL){
	            print("不要再玩了，快去写代码吧")
	            possibleSkills.subtractInPlace(.LOL)
	        }
	    }
	    mutating func signUpStackOverflow() {
	        if !possibleSkills.contains(.StackOverflow) {
	            possibleSkills.unionInPlace(.StackOverflow)
	            print("StackOverflow 帐号注册完毕，可以上去提问题了")
	        } else {
	            print("你已经有 StackOverflow 账号了，先去回答几个问题吧")
	        }
	    }
	    mutating func signUpGitHub() {
	        if !possibleSkills.contains(.GitHub) {
	            possibleSkills.unionInPlace(.GitHub)
	            print("GitHub 帐号注册完毕，快去骗 star 吧.")
	        } else {
	            print("你已经有 GitHub 了，请不要重复注册.")
	        }
	    }
	}

	var programmer = Programmer()
	programmer.quitLOL()
	programmer.signUpGitHub()
	programmer.signUpStackOverflow()
 ```
