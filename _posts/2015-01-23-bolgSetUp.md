---
layout: post
title: "Jekyll博客搭建"
date: 2015-01-23
comments: true
categories: iOS
tags: [Jekyll]
keywords: Jekyll blog 迁移到gitcafe
description: Jekyll博客搭建, 迁移到gitcafe
---

由于博客已经换了搭建平台和主题，之前文章的评论已丢失，在这里对那些做过评论的网友说声抱歉。

把博客平台换成[Jekyll](http://jekyllcn.com/)，主要原因是这款令我满意的主题，而且Jekyll搭建和操作也非常简单。下面介绍在Mac OS X环境下如何通过Jekyll搭建自己的个人博客。

####搭建环境

首先安装必要工具

* [Ruby](https://www.ruby-lang.org/en/downloads/)：Mac OS X 10.5以上都自带
* [RubyGems](https://rubygems.org/pages/download)：Mac OS X 10.5以上都自带
* [NodeJS](http://nodejs.org/)：命令行输入`node -v`检查是否已安装，下载地址：http://nodejs.org/
* Xcode Command-Line Tools： 安装Xcode会自动安装，检查`Preferences → Downloads → Components`是否有Command-Line Tools这项提供下载，如果没有说明已安装
* [git](http://sourceforge.net/projects/git-osx-installer/)：命令行输入`git --version`检查是否已安装，下载地址：http://sourceforge.net/projects/git-osx-installer/


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
2. 把fork后的项目名改为：`xxxxxx.github.io`xxxx为你的github用户名，比如我的用户名是bawn，那么就需要修改成`bawn.github.io`，这个也正是你博客的地址。
点击项目右侧 settings 菜单，进入后修改 `Repository name`就是了。

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


####替换谷歌字体库

网站打开慢？刚搭完博客我也在郁闷这个事，然后通过google的网站分析发现是JS加载google的字体库造成找到/_layouts/default.html，把下面代码中的Google免费字体库的域名`googleapis`替换成[360](http://libs.useso.com]/)提供的代理`useso`的，

{% highlight ruby %}

<link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Merriweather:300,700,700italic,300italic|Open+Sans:700,400" />
// 替换后
<link rel="stylesheet" type="text/css" href="//fonts.useso.com/css?family=Merriweather:300,700,700italic,300italic|Open+Sans:700,400" />
{% endhighlight %}

###配置博客的相关信息
在`_config.yml`文件中修改，比如我的配置如下

{% highlight ruby %}
name: Bawn
description: Blogging about stuffs
meta_description: "Bawn's Blog"

markdown: redcarpet
redcarpet:
extensions: ["no_intra_emphasis", "fenced_code_blocks", "autolink", "tables", "with_toc_data"]

highlighter: pygments
logo: false
paginate: 20
baseurl: /
domain_name: 'http://bawn.github.io/'
google_analytics: 'UA-XXXXXXXX-X'

# Details for the RSS feed generator
url:            '/rss.xml'
author:         'Bawn'
{% endhighlight %}

####添加多说评论

将 `_layouts/post.html` 中的 `<footer class="post-footer">` 到 `</footer>`之间的内容替换为多说的评论代码，比如我替换后是这样的:

![image](/images/Jekyll/duoshuo.png)
不过多说代码中的`data-thread-key` 目前不知道怎么赋值，若有知道的同学请告诉我下。
