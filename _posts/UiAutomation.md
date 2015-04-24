---
layout: post
title: "UI自动化测试"
date: 2015-04-21
comments: true
categories: iOS
tags: [UI, iOS, UiAutomation]
keywords: UI自动化测试 iOS
publish: false
description: iOS UI自动化测试
---

秉着想偷懒的原则和测试这块一直存在的诟病，空闲的时把苹果提供的UIAutomation研究了一番，心想这样就可以坐等APP自己跑完所有流程然后输出 carsh 报告。但是想象很丰满，现实很骨感，UiAutomation 并没有想象中那么的完美。<br>

##基本介绍

`⌘ + I` 打开Instruments，选择 UiAutomation

![image](/images/UiAutomation/tool.png)

① 开始、结束测试按钮，选择设备和项目菜单<br>
② JS脚本编辑区，Trace Log 和 Editor Log显示区<br>
③ 自动化测试时间线<br>
④ 其他菜单页面<br>
⑤ 脚本或是Log选择菜单<br>
⑥ 自动生成JS脚本代码的开始、结束和停止按钮<br>

看一个简单的例子，APP的界面上有一个UITextField，称之为`A元素`，Navigationbar有个rightItem，称之为`B元素`，点击rightItem会push到另一个VC
![image](/images/UiAutomation/screen.png)

在④中选择一个空的脚本写入下列代码，对 JS 不了解的也不用当心，自动化测试的 JS 代码非常简单。
{% highlight ruby %}
var target = UIATarget.localTarget();
var app = target.frontMostApp();
var window = app.mainWindow();
// 打印元素树
app.logElementTree();
{% endhighlight %}

`⌘ + R`跑一下，②区域应该会自动切换到Log界面
![image](/images/UiAutomation/log.png)

Log打印出来的是当前界面的元素（UIAElement）树，同层级的元素会被包含到数组中，模拟用户操作其实就是对元素的操作，那么获取到元素才是关键。<br>
**补充脚本：**
{% highlight ruby %}
var target = UIATarget.localTarget();
var app = target.frontMostApp();
var window = app.mainWindow();
app.logElementTree();
var textField = window.textFields()[0];
// 在 A 元素中输入122
textField.setValue("122");
// 停顿1秒
target.delay(1);
// 获取 B 元素
var rightButton = window.navigationBar().buttons()['Button'];
// 点击 B 元素
rightButton.tap();
{% endhighlight %}

运行后的效果是：A 元素被输入了122的字符，然后 B 元素被点击，APP 进入了一个页面

代码解读：

* 获取 A 元素：`window.textFields()[0]`，界面上只有一个textField，那么当然是textFields数组的第一个元素
* 获取 B 元素：`window.navigationBar().buttons()['Button']`，由于 B 元素是在navigationBar上，所以需要先获取navigationBar，再从buttons数组中获取 B 元素，通过 B 元素`name`属性的值`Button`(默认值)获取。

元素的`name`值也可以手动设置，比如设置 A 元素的`name`值为`textField`，注意：不要设置元素的可访问性（isAccessibilityElement）为NO
![image](/images/UiAutomation/label.png)
或者用代码设置
{% highlight ruby %}
self.aView.accessibilityLabel = @"textField";
{% endhighlight %}

那么就可以通过下面这种方式获取

{% highlight ruby %}
var textField = window.textFields()['textField'];
{% endhighlight %}

关于元素的可执行方法，比如`tap()`，可以查看苹果的[官方文档](https://developer.apple.com/library/ios/documentation/DeveloperTools/Reference/UIAutomationRef/)。

**以及元素数组包括：**

{% highlight ruby %}
1. buttons()
2. images()
3. scrollViews()
4. textFields()
5. webViews()
6. segmentedControls()
7. sliders()
8. staticTexts()
9. switches()
10. tabBar()
11. tableViews()
12. textViews()
13. toolbar()
14. toolbars()
15. secureTextFields() // 加密的UITextField
...
{% endhighlight %}

苹果另外也提供一个辅助检查功能工具，可以方便查看元素的信息<br>打开设置（Settings）-- 通用（General）-- 辅助功能（Accessibility）-- 辅助功能检查器（Accessibility Inspector）

![image](/images/UiAutomation/accessibility.png)


##操作脚本录制


在④中创建一个新的脚本，在⑥中点击中间的红色按钮，代表开始录制用户操作并转换为JS代码，点击右侧的按钮，停止录制，左侧按钮，执行脚本。这时候你肯定在想，既然有这功能，还需要写什么脚本啊。

{% highlight ruby %}
target.frontMostApp().mainWindow().textFields()[0].textFields()[0].tap();
target.frontMostApp().keyboard().typeString("e");
target.frontMostApp().navigationBar().buttons()["Button"].tap();
{% endhighlight %}


















__参考：[知平软件](http://www.cnblogs.com/vowei/archive/2012/08/10/2631949.html#3105924)__