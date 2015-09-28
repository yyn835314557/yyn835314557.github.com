#MVVM介绍(Model-View-ViewModel)

Swift中使用KVC和KVO的类都必须必须继承自NSObject

***
> KVC(key-value coding: 键值编码):是1种间接访问对象的机制,key的值就是属性名称的字符串，返回的value是任意类型，需要自己转化为需要的类型,
	KVC主要就是两个方法:（1）通过key设置对应的属性;（2）通过key获得对应的属性;

> KVO(key-value observing: 键值监听):建立在KVC之上的的机制,主要功能是检测对象属性的变化,这是1个完善的机制，不需要用户自己设计复杂的视察者模式,对需要视察的属性要在前面加上dynamic关键字

