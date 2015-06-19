---
layout: post
title: "带有简单动画的PageControl"
date: 2015-06-16
comments: true
categories: iOS UIPageControl
tags: [UIPageControl, iOS]
keywords: UIPageControl iOS
publish: true
description: 带有动画的UIPageControl
---

开源一个带有简单动画的PageControl控件，地址[GitHub](https://github.com/bawn/LCAnimatedPageControl)。
在项目中的使用效果：

![1](/images/LCAnimatedPageControl/demo.gif)

__使用方法:__
{% highlight ruby %}

self.pageControl = [[LCAnimatedPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 280, 20)];
self.pageControl.center = CGPointMake(self.view.frame.size.width * 0.5f, _pageControl.center.y);
self.pageControl.numberOfPages = 5;指示器的数量
self.pageControl.indicatorMargin = 5.0f;// 指示器之间的间隔，默认是0
self.pageControl.indicatorMultiple = 1.6f;// 指示器的放大倍数，默认是2
pageControl.pageIndicatorColor = [UIColor grayColor];// 普通状态下的颜色
pageControl.currentPageIndicatorColor = [UIColor redColor];// 当前状态下的颜色
self.pageControl.sourceScrollView = _collectionView;
[self.pageControl prepareShow];// 全部属性设置完后再调用
[self.view addSubview:_pageControl];

{% endhighlight %}

注意，`indicatorMargin`调整的间距是两个指示器都在放大状态下的距离，图示：
![2](/images/LCAnimatedPageControl/indicatorMargin.png)


另外和和原生的`UIPageControl`一样，监听当前显示指示器的位置变化，使用的是`target - action`的形式：

{% highlight ruby %}
[pageControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
{% endhighlight %}

##TODO

1. <del>增加调整指示器数量的功能</del>
2. 尝试解决跨多个指示器的动画不能复原的问题，所以目前指示器的点击只能跳转到相邻的位置
