---
layout: post
title: "valueForKeyPath"
date: 2014-05-07
comments: true
categories: iOS
tags: [KVC, valueForKeyPath]
keywords: iOS KVC valueForKeyPath
description: valueForKeyPath方法的强大之处
---
或许大家在平常的开发中`- (id)valueForKeyPath:(NSString *)keyPath`方法用的不多

但是这个方法非常强大，举个例子:

{% highlight ruby %}
NSArray *array = @[@"name", @"w", @"aa", @"jimsa"];
NSLog(@"%@", [array valueForKeyPath:@"uppercaseString"]);
{% endhighlight %}

输出

{% highlight ruby %}
(
    NAME,
    W,
    AA,
    JIMSA
)
{% endhighlight %}

相当于数组中的每个成员执行了`uppercaseString`方法，然后把返回的对象组成一个新数组返回。既然可以用`uppercaseString`方法，那么NSString的其他方法也可以，比如

{% highlight ruby %}
[array valueForKeyPath:@"length"]
{% endhighlight %}

返回每个字符串长度的组成的数组。只要你能想到的成员实例方法都可以这么用。

如果你觉得这个方法就这么点功能，那就错了。还是举具体的例子

- __对NSNumber数组快速计算数组求和、平均数、最大值、最小值__
{% highlight ruby %}
NSArray *array = @[@1, @2, @3, @4, @10];
NSNumber *sum = [array valueForKeyPath:@"@sum.self"];
NSNumber *avg = [array valueForKeyPath:@"@avg.self"];
NSNumber *max = [array valueForKeyPath:@"@max.self"];
NSNumber *min = [array valueForKeyPath:@"@min.self"];
{% endhighlight %}
或者指定输出类型
{% highlight ruby %}
NSNumber *sum = [array valueForKeyPath:@"@sum.floatValue"];
NSNumber *avg = [array valueForKeyPath:@"@avg.floatValue"];
NSNumber *max = [array valueForKeyPath:@"@max.floatValue"];
NSNumber *min = [array valueForKeyPath:@"@min.floatValue"];
{% endhighlight %}

* __剔除重复数据__
{% highlight ruby %}
NSArray *array = @[@"name", @"w", @"aa", @"jimsa", @"aa"];
NSLog(@"%@", [array valueForKeyPath:@"@distinctUnionOfObjects.self"]);
{% endhighlight %}
{% highlight ruby %}
(
    name,
    w,
    jimsa,
    aa
)
{% endhighlight %}


* __对NSDictionary数组快速找出相应key对的值__

{% highlight ruby %}
 NSArray *array = @[@{@"name" : @"cookeee",
                         @"code" : @1},
                       @{@"name" : @"sswwre",
                         @"code" : @2}];
NSLog(@"%@", [array valueForKeyPath:@"name"]);
NSLog(@"%@", [array valueForKeyPath:@"name"]);
{% endhighlight %}
直接得到字典中`name`key对应的值组成的数组，显然比循环取值再加入到新数组中方便快捷
{% highlight ruby %}
(
    cookeee,
    jim,
    jim,
    jbos
)
{% endhighlight %}
甚至嵌套使用，先剔除`name`对应值的重复数据再取值
{% highlight ruby %}
NSArray *array = @[@{@"name" : @"cookeee",@"code" : @1},
                           @{@"name": @"jim",@"code" : @2},
                           @{@"name": @"jim",@"code" : @1},
                           @{@"name": @"jbos",@"code" : @1}];

NSLog(@"%@", [array valueForKeyPath:@"@distinctUnionOfObjects.name"]);
{% endhighlight %}
{% highlight ruby %}
(
    cookeee,
    jim,
    jbos
)
{% endhighlight %}

* __改变UITextfiedl的placeholder的颜色__
{% highlight ruby %}
    [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
{% endhighlight %}
比起重写`- (void)drawPlaceholderInRect:(CGRect)rect;`要方便很多

