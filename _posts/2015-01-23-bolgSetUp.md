---
layout: post
title: "Jekyll博客搭建"
date: 2015-01-23
comments: true
categories: iOS
tags: [Jekyll]
keywords: Jekyll blog
description: Jekyll博客搭建
---


由于博客已经换了搭建平台和主题，之前文章的评论已丢失，在这里对那些做过评论的网友说声抱歉。


<!--从开始接触个人博客到现在，自己一共试过了三个博客搭建平台：

* [Octopress](http://octopress.org/)
* [Hexo](http://hexo.io/)
* [Jekyll](http://jekyllrb.com/)	

放弃Octopress和Hexo原因是这两个平台没有令我满意的主题-->
把博客平台换成[Jekyll](http://jekyllcn.com/)，主要原因是这款令我满意的主题，而且Jekyll搭建和操作也非常简单。下面我来介绍在Mac OS X环境下如何通过Jekyll搭建自己的个人博客。
<!---->
####搭建环境

首先安装必要工具

* [Ruby](https://www.ruby-lang.org/en/downloads/)：Mac OS X 10.5以上都自带
* [RubyGems](https://rubygems.org/pages/download)：Mac OS X 10.5以上都自带
* [NodeJS](http://nodejs.org/)：http://nodejs.org/ 下载安装即可。
* Xcode Command-Line Tools: 安装Xcode会自动安装，检查`Preferences → Downloads → Components`是否有Command-Line Tools这项提供下载，如果没有说明已安装。
* [git](http://sourceforge.net/projects/git-osx-installer/)：通过http://sourceforge.net/projects/git-osx-installer/ 下载安装即可


命令行安装Jekyll
{% highlight ruby %}
sudo gem install jekyll
{% endhighlight %}

安装慢？国内网络你懂的。解决办法：替换gem官方镜像源

{% highlight ruby %}
// 移除官方镜像源
gem sources --remove https://rubygems.org/
// 添加淘宝镜像源
gem sources -a http://ruby.taobao.org/
{% endhighlight %}

验证是否替换成功`gem sources -l`，出现
{% highlight ruby %}
*** CURRENT SOURCES ***
http://ruby.taobao.org/
{% endhighlight %}
即可

####安装主题

1. Fork我使用的这款主题[kasper](https://github.com/rosario/kasper)
2. 修改这个项目的名称为：`xxxxxx.github.io`xxxx为你的github用户名，比如我的用户名是bawn，那么就需要修改成`bawn.github.io`，这个也正是你博客的地址

完成这两步之后，在你的浏览器上输入xxxxxx.github.io或者xxxxxx.github.com，就会出现你个人博客的页面(可能需要等待几分钟)，这时候你的博客上	应该有一篇主题作者的默认文章叫做Welcome to Jekyll!


####发表文章


{% highlight ruby %}
// 进入主题需要放置的目录
cd Documents
// 克隆刚才fork的主题
git clone https://github.com/xxxx/xxxxx.github.io
{% endhighlight %}

完成之后你的Documents目录下应该有个xxxxx.github.io的文件夹（称之为博客目录），_posts文件夹中的markdown文件就是所发表的文章的源文件。
新建一篇文章的命名规则是`xxxx-xxx-xx-xxxxxxx.md`，比如我这篇文章的命名是`2015-01-23-bolgSetUp`，里面内容也需要一定的规则，下面是这篇文章的头部的写法

{% highlight ruby %}
---
layout: post
title: "Jekyll博客搭建"
date: 2015-01-23
comments: true
categories: iOS
tags: [Jekyll]
keywords: Jekyll blog
description: Jekyll博客搭建
---

由于博客已经换了搭建平台和主题，之前文章的评论已丢失，在这里对那些做过评论的网友说声抱歉。
{% endhighlight %}

Jekyll提供了本地预览功能，命令行进入博客目录，执行：

{% highlight ruby %}
jekyll server
{% endhighlight %}

在浏览器地址栏中输入：http://localhost:4000/ 就可以进行本地预览。新增、修改、删除文章都可以实时的看到，只需要刷新页面,可以试着修改默认那篇文章看看效果。

发表文章和提交git项目修改一样，基本流程大概是这样的，博客目录下执行

{% highlight ruby %}
git add .
git commit -m 'xxxxx'
git push
{% endhighlight %}

完成之后应该就能看到新的文章已经在你的个人博客主页上了。




