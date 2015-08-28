---
layout: post
title: "杂记"
date: 2014-11-24
update: 2015-04-7
comments: true
categories: iOS
tags: [iOS]
published: ture
keywords: iOS
description: iOS杂记
---

很久没更新博客了，一方面是.......另一方面是项目忙

回归正题，将近一年的开发过程中，我都会把学习到的一些东西记录下来，工具用的是[印象笔记](https://www.yinxiang.com/)，这确实是个不错的学习方法。不过印象笔记并不支持markdown，网上也有很多方法让笔记以markdown语法的格式保存到印象笔记中。目前我用的是[马克飞象](http://marxi.co/)这款工具，比较方便，专业版是收费的。

下面是我两年来一些无分类的琐碎笔记，或许有些对大家有帮助

###将数组切割成字符串
{% highlight ruby %}
NSArray *array=[[NSArray alloc]initWithObjects:@"苹果",@"香蕉",@"草莓", @"菠萝", nil];
NSString *newString=[array componentsJoinedByString:@","];    
NSLog(@"%@", newString);
{% endhighlight %}
{% highlight ruby %}
2013-10-29 15:38:23.372 Nurse[4001:c07] 苹果,香蕉,草莓,菠萝
{% endhighlight %}
___
###将字符串切割成数组
{% highlight ruby %}
- (void)viewDidLoad
{
    NSString *a = [[NSString alloc] initWithString : @"冬瓜，西瓜，火龙果，大头，小狗" ];
    NSArray *b = [a componentsSeparatedByString:@"，"];
}
{% endhighlight %}
___
###获得UIColor获得RGB值
{% highlight ruby %}
	CGFloat R, G, B;
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    R = components[0];
    G = components[1];
    B = components[2];
{% endhighlight %}
___
###抗锯齿
有些时候图片旋转后会存在一些比较严重的锯齿效果

解决办法：在项目plist文件中添加名为`UIViewEdgeAntialiasing的key`并设置为`YES`，但是这样可能会对性能产生严重的影响。
Apple的解释：
>Use antialiasing when drawing a layer that is not aligned to pixel boundaries. This option allows for more sophisticated rendering in the simulator but can have a noticeable impact on performance.

简单办法：原始图片的四周做一个1像素的透明
___

### 屏幕截图
iOS 7之后
{% highlight ruby %}
    UIGraphicsBeginImageContextWithOptions(_sourceViewController.view.frame.size, YES, 0.0);
    [self.sourceViewController.view.window drawViewHierarchyInRect:_sourceViewController.view.frame afterScreenUpdates:NO];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
{% endhighlight %}
____
###隐藏键盘(点击屏幕任意位置)
在VC中重写
{% highlight ruby %}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{% endhighlight %}
方法
{% highlight ruby %}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
{% endhighlight %}
___
###在包含UITableView视图中添加单击手势
如果在包含UITableView视图中添加单击手势，这个单击手势会屏蔽掉UITableView的

{% highlight ruby %}
    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{% endhighlight %}

可以利用`UIGestureRecognizer`的`Delegate`中的

{% highlight ruby %}
    - (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
{% endhighlight %}

在单击点位于UITableView内的时候取消响应

{% highlight ruby %}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:self];
    if(CGRectContainsPoint(menuTableView.frame, point)){
        return NO;
    }
    return YES;
}
{% endhighlight %}

简单点的就将单击手势的cancelsTouchesInView设置为NO即可
{% highlight ruby %}
singleTap.cancelsTouchesInView = NO;
{% endhighlight %}
___
###URLWithString:返回nil
解决办法
{% highlight ruby %}
NSString *tempString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
NSURL *url = [NSURL URLWithString:tempString];
{% endhighlight %}
___
###判断string是否包含中文
{% highlight ruby %}
NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[\u4e00-\u9fa5]" options:0 error:nil];

    // 返回中文的个数numberOfMatches
NSUInteger numberOfMatches = [regularExpression numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])];
{% endhighlight %}
___
###度数转换为弧度
{% highlight ruby %}
#define tranformDegree(x) ((x)*(M_PI)/(180.0f))
{% endhighlight %}

弧度 = 角度* π / 180
___
###快速定位cell
通过在cell中的子视图，例子中是button
{% highlight ruby %}
NSIndexPath *path = [_collectionView indexPathForItemAtPoint:[button convertPoint:CGPointZero toView:self.collectionView]];
{% endhighlight %}
适用于UITableView(API不同)和UICollectionView
___

###判断一个view是否是另一个view的子视图
{% highlight ruby %}
    - (BOOL)isDescendantOfView:(UIView *)view;
{% endhighlight %}
___
###解决64位上%d和%u警告
{% highlight ruby %}
#if __LP64__
#define NSI "ld"
#define NSU "lu"
#else
#define NSI "d"
#define NSU "u"
#endif
{% endhighlight %}
使用
{% highlight ruby %}
NSInteger row = 2;
NSLog(@"i=%"NSI@"其他文字", row);
{% endhighlight %}
___
###?语法
{% highlight ruby %}
NSLog(@"%@", @"a" ?: @"b"); // @"a"
{% endhighlight %}
如果成立返回`?`语法的消息接收者，这里就是@"a"。常用:
{% highlight ruby %}
cell.titleLabel.text = self.name ?:nil;
{% endhighlight %}
___
###跳转到系统设置界面(只适用用iOS 8)
{% highlight ruby %}
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
{% endhighlight %}
___
###跳转到APP Store（iOS 7之后）
跳转到产品详情界面

{% highlight ruby %}
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/idxxxxxx"]];
{% endhighlight %}

跳转到产品评论界面

{% highlight ruby %}
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=xxxxxx&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
{% endhighlight %}
xxxxx是的Apple ID
___
###消除UINavigationBar的底部的一像素线
{% highlight ruby %}
[self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
{% endhighlight %}
恢复
{% highlight ruby %}
[self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
self.navigationController.navigationBar.shadowImage = nil;
{% endhighlight %}

___

###判断滑动方法
* 纵向
{% highlight ruby %}
CGPoint velocity = [sender velocityInView:self];
BOOL isVerticalGesture = fabsf(velocity.y) >= fabsf(velocity.x);
{% endhighlight %}

* 横向
{% highlight ruby %}
CGPoint velocity = [self.panGestureRecognizer velocityInView:self.panGestureRecognizer.view];
BOOL isHorizontalGesture = fabs(velocity.y) <= fabs(velocity.x);
{% endhighlight %}
___
###UIScrollView滚动到顶部

{% highlight ruby %}
self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);
{% endhighlight %}

___
###APP中禁用第三方键盘

{% highlight ruby %}
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier {
    if ([extensionPointIdentifier isEqualToString: UIApplicationKeyboardExtensionPointIdentifier]) {
        return NO;
    }
    return YES;
}
{% endhighlight %}
