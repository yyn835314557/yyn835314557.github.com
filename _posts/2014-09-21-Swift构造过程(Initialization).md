---
layout: post
title: "Swift构造过程(Initialization)"
date: 2014-09-21
comments: true
categories: Swift
tags: [Swift Initialization] 
keywords: Swift 构造过程 
description: 2014-09-21-Swift构造过程(Initialization)
---

本文主要介绍Swift语言的中class、struct、enum的构造过程，构造器的定义。注意比较值类型(默认构造器逐一初始化,属性不需要赋初值)与引用类型(init())的构造的比较

> 构造过程是为了使用某个类、结构体或枚举类型的实例而进行的准备过程。这个过程包含了为实例中的每个存储
型属性设置初始值和为其执行必要的准备和初始化任务。

> 构造过程是通过定义构造器( Initializers )来实现的,这些构造器可以看做是用来创建特定类型实例的特殊方 法。与 Objective-C 中的构造器不同,Swift 的构造器无需返回值,它们的主要任务是保证新实例在第一次使用 前完成正确的初始化。

###存储属性的初始赋值
类和结构体在实例创建时,必须为所有存储型属性设置合适的初始值。存储型属性的值不能处于一个未知的状态。

你可以在构造器中为存储型属性赋初值,也可以在定义属性时为其设置默认值

> 当你为存储型属性设置默认值或者在构造器中为其赋值时,它们的值是被直接设置的,不会触发任何属性观测器( property observers )。

- 默认属性值: 在构造器中为存储型属性设置初始值;同样,你也可以在属性声明时为其设置默认值

###自定义构造器

你可以通过输入参数和可选属性类型来定义构造过程,也可以在构造过程中修改常量属性。

*构造参数*

```Swift
struct Celsius{
    var temperatureCelsius:Double = 0.0
    init(fromFahrenheit fahrenheit:Double){
        temperatureCelsius = (fahrenheit - 32) / 1.8
    }
    init(fromKelvin kelvin:Double){
        temperatureCelsius = kelvin - 273.15
    }
}
let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
let freezingPointOfWater = Celsius(fromKelvin: 273.15)
```
*参数的内部名称与外部名称*

跟函数和方法参数相同,构造参数也存在一个在构造器内部使用的参数名字和一个在调用构造器时使用的外部参
数名字。Swift 会为每个构造器的参数自动生成一个跟内部名字相同的外部名,就相当于在每个构造参数之前加了一个 哈希符号。

```Swift
struct Color {
    let red, green, blue: Double
    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    init(white: Double) {
        red = white;
        green = white
        blue = white
    }
}
let magenta = Color(red: 1.0, green: 0, blue: 1.0)
let halfGray = Color(white: 0.5)
let white = Color(white: 1.0)
let black = Color(white: 0.0)
```

*不带外部名的构造器参数*

如果你不希望为构造器的某个参数提供外部名字,你可以使用下划线(_)来显示描述它的外部名,以此重写上面所 说的默认行为

```Swift
struct Celsius {
	var temperatureInCelsius: Double = 0.0 
	init(fromFahrenheit fahrenheit: Double) {
		temperatureInCelsius = (fahrenheit - 32.0) / 1.8 
	}
	init(fromKelvin kelvin: Double) { 
		temperatureInCelsius = kelvin - 273.15
	}
	init(_ celsius: Double){
		temperatureInCelsius = celsius 
	}
}
let bodyTemperature = Celsius(37.0)
// bodyTemperature.temperatureInCelsius 为 37.0
```

*可选属性类型*

如果你定制的类型包含一个逻辑上允许取值为空的存储型属性--不管是因为它无法在初始化时赋值,还是因为它 可以在之后某个时间点可以赋值为空--你都需要将它定义为可选类型 optional type 。可选类型的属性将自动初 始化为空 nil ,表示这个属性是故意在初始化时设置为空的。

```Swift
class SurveyQuestion { 
	var text: String
	var response: String? 
	init(text: String) {
		self.text = text 
	}
	func ask() { 
		print(text)
	} 
}
let cheeseQuestion = SurveyQuestion(text: "Do you like cheese?") cheeseQuestion.ask()
// 输出 "Do you like cheese?"
cheeseQuestion.response = "Yes, I do like cheese."
```

*构造过程中常量属性的修改*

只要在构造过程结束前常量的值能确定,你可以在构造过程中的任意时间点修改常量属性的值。

> 注意:
 对某个类实例来说,它的常量属性只能在定义它的类的构造过程中修改;不能在子类中修改。

*默认构造器*

Swift 将为所有属性已提供默认值的且自身没有定义任何构造器的结构体或基类,提供一个默认的构造器。这个默认构造器将简单的创建一个所有属性值都设置为默认值的实例。

```Swift
class ShoppingListItem { 
	var name: String?
	var quantity = 1
	var purchased = false
}
var item = ShoppingListItem()
```

*结构体的逐一成员构造器*

除上面提到的默认构造器,如果结构体对所有存储型属性提供了默认值且自身没有提供定制的构造器,它们能自动获得一个逐一成员构造器。

```Swift
struct Size {
 var width = 0.0 
 var height = 0.0
}
let twoByTwo = Size(width: 2.0, height: 2.0)
```

> Note:
 class必须赋初值或者设置为可选类型，无构造器自动产生无参数构造器；struct可以不赋初值,所有属性在实例化后必须有值(可选的自动赋值为nil),产生无值参数的逐一赋值的构造器。

*值类型的构造器代理*

构造器可以通过调用其它构造器来完成实例的部分构造过程。这一过程称为构造器代理,它能减少多个构造器间
的代码重复。

构造器代理的实现规则和形式在值类型和类类型中有所不同。值类型(结构体和枚举类型)不支持继承,所以构造器代理的过程相对简单,因为它们只能代理给本身提供的其它构造器。类则不同,它可以继承自其它类,这意味着类有责任保证其所有继承的存储型属性在构造时也能正确的初始化

 - 值类型(struct,enum): 它们只能代理给本身提供的其它构造器
	 - `self.init`
	 - 如果你为某个值类型定义了一个定制的构造器,你将无法访问到默认构造器(如果是结构体,则无法访问逐一对象构造器)。这个限制可以防止你在为值类型定义了一个更复杂的,完成了重要准备构造器之后,别人还是错误的使用了那个自动生成的构造器。

 > 假如你想通过默认构造器、逐一对象构造器以及你自己定制的构造器为值类型创建实例,建议你将自己定制的构造器写到扩展( extension )中,而不是跟值类型定义混在一起。

 ```Swift
 struct Size {
 	var width = 0.0, height = 0.0
 }
 struct Point {
 	var x = 0.0, y = 0.0 
 }
 struct Rect {
 	var origin = Point()
 	var size = Size()
	init() {}
	init(origin: Point, size: Size) {
		self.origin = origin
		self.size = size 
	}
	init(center: Point, size: Size) {
 		let originX = center.x - (size.width / 2)
 		let originY = center.y - (size.height / 2) 
 		self.init(origin: Point(x: originX, y: originY), size: size)
 	} 
 }

 let basicRect = Rect()
 // basicRect 的原点是 (0.0, 0.0),尺寸是 (0.0, 0.0)
 let originRect = Rect(origin: Point(x: 2.0, y: 2.0), size: Size(width: 5.0, height: 5.0))
 // originRect 的原点是 (2.0, 2.0),尺寸是 (5.0, 5.0)
 let centerRect = Rect(center: Point(x: 4.0, y: 4.0), size: Size(width: 3.0, height: 3.0))
 // centerRect 的原点是 (2.5, 2.5),尺寸是 (3.0, 3.0)
 ```

*类的继承和构造代理*

类里面的所有存储型属性--包括所有继承自父类的属性--都必须在构造过程中设置初始值。

Swift 提供了两种类型的类构造器来确保所有类实例中存储型属性都能获得初始值,它们分别是指定构造器和便利 构造器。

*指定构造器*
	
	- 指定构造器是类中最主要的构造器。一个指定构造器将初始化类中提供的所有属性,并根据父类链往上调用父类
	 的构造器来实现父类的初始化。
	- 每一个类都必须拥有至少一个指定构造器。在某些情况下,许多类通过继承了父类中的指定构造器而满足了这个条件。

 ```Swift
 init(parameters){
 	statements
 }
 // 与值类型简单构造器写法一样
 ```

*便利构造器*
	- 便利构造器是类中比较次要的、辅助型的构造器。你可以定义便利构造器来调用同一个类中的指定构造器,并为
	 其参数提供默认值。你也可以定义便利构造器来创建一个特殊用途或特定输入的实例。
	- 你应当只在必要的时候为类提供便利构造器,比方说某种情况下通过使用便利构造器来快捷调用某个指定构造
 	 器,能够节省更多开发时间并让类的构造过程更清晰明了。

 ```Swift
 convenience init(parameters){
 	statements
 }
 ```

*类的构造器代理规则*
	
	- 指定构造器必须调用其直接父类的的指定构造器。
	- 便利构造器必须调用同一类中定义的其它构造器。
	- 便利构造器必须最终以调用一个指定构造器结束。

 > Note:
 1. 指定构造器必须总是向上代理
 2. 便利构造器必须总是横向代理

*两段式构造过程*

Swift中类的构造过程包含两个阶段。第一个阶段,每个存储型属性通过引入它们的类的构造器来设置初始值。当 每一个存储型属性值被确定后,第二阶段开始,它给每个类一次机会在新实例准备使用之前进一步定制它们的存 储型属性。

两段式构造过程的使用让构造过程更安全,同时在整个类层级结构中给予了每个类完全的灵活性。两段式构造过
程可以防止属性值在初始化之前被访问;也可以防止属性被另外一个构造器意外地赋予不同的值。

Swift 编译器将执行 4 种有效的安全检查,以确保两段式构造过程能顺利完成:
	
	- 安全检查1: 指定构造器必须保证它所在类引入的所有属性都必须先初始化完成,之后才能将其它构造任务向上代理给父类中 的构造器
	- 安全检查2: 指定构造器必须先向上代理调用父类构造器,然后再为继承的属性设置新值。如果没这么做,指定构造器赋予的 新值将被父类中的构造器所覆盖。
	-￼安全检查3: 便利构造器必须先代理调用同一类中的其它构造器,然后再为任意属性赋新值。如果没这么做,便利构造器赋予 的新值将被同一类中其它指定构造器所覆盖。
	- 安全检查4: 构造器在第一阶段构造完成之前,不能调用任何实例方法、不能读取任何实例属性的值, self 的值不能被引用。类实例在第一阶段结束以前并不是完全有效,仅能访问属性和调用方法,一旦完成第一阶段,该实例才会声明为有效实例。

 两段式构造过程中基于上述安全检查的构造流程展示:
 	- 阶段一
 		- 某个指定构造器或便利构造器被调用;
		- 完成新实例内存的分配,但此时内存还没有被初始化;
		- 指定构造器确保其所在类引入的所有存储型属性都已赋初值。存储型属性所属的内存完成初始化;
		- 指定构造器将调用父类的构造器,完成父类属性的初始化;
		- 这个调用父类构造器的过程沿着构造器链一直往上执行,直到到达构造器链的最顶部;
		- 当到达了构造器链最顶部,且已确保所有实例包含的存储型属性都已经赋值,这个实例的内存被认为已经完 全初始化。此时阶段1完成。
 	- 阶段二
 		- 从顶部构造器链一直往下,每个构造器链中类的指定构造器都有机会进一步定制实例。构造器此时可以访问self 、修改它的属性并调用实例方法等等。
		- 最终,任意构造器链中的便利构造器可以有机会定制实例和使用 self 。

 ![构造阶段](/images/initialization/构造阶段.png)

*构造器的继承和重写*

跟 Objective-C 中的子类不同,Swift 中的子类不会默认继承父类的构造器。Swift 的这种机制可以防止一个父类的简单构造器被一个更专业的子类继承,并被错误的用来创建子类的实例。父类的构造器仅在确定和安全的情况下被继承。

当你重写一个父类指定构造器时,你需要写 override 修饰符,甚至你的子类构造器继承的是父类的便利构造器。
 
 ```
 class Vehicle {
	var numberOfWheels = 0 
	var description: String {
		return "\(numberOfWheels) wheel(s)" 
	}
 }
 let vehicle = Vehicle()
 print("Vehicle: \(vehicle.description)") 
 // Vehicle: 0 wheel(s)

 class Bicycle: Vehicle { 
 	override init() {
		super.init()
		numberOfWheels = 2 
	}
 }

 let bicycle = Bicycle()
 print("Bicycle: \(bicycle.description)") // Bicycle: 2 wheel(s)
 ```

*自动构造器的继承*

子类不会默认继承父类的构造器。但是如果特定条件可以满足,父类构造器是可以被自动继承的。在实践中,这意味着对于许多常见场景你不必重写父类的构造器,并且在尽可能安全的情况下以最小的代价来继承父类的构造器。

假设要为子类中引入的任意新属性提供默认值,请遵守以下2个规则:

	- 规则1: 如果子类没有定义任何指定构造器,它将自动继承所有父类的指定构造器。
	- 规则2: 如果子类提供了所有父类指定构造器的实现--不管是通过规则1继承过来的,还是通过自定义实现的--它将自动继承所有父类的便利构造器。即使你在子类中添加了更多的便利构造器,这两条规则仍然适用。

*指定构造器和便利构造器*

![三类构造器](/images/initialization/init.png)

 ```Swift
 // Food 类没有父类,所以 init(name: String) 构造器不需要调用 super.init() 来完成构造。
 class Food {
    var name:String
    init(name:String){
        self.name = name
    }
    convenience init(){
        self.init(name:"[Unnamed]")
    }
 }
 let namedMeat = Food(name: "Bacon")
 let mysteryMeat = Food()

 class RecipeIngredient:Food {
    var quantity:Int
    init(name: String,quantity:Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    override convenience init(name: String) {
        self.init(name:name,quantity:1)
    }
 }
 let oneMysteryItem = RecipeIngredient()
 let oneBacon = RecipeIngredient(name: "Bacon")
 let sixEggs = RecipeIngredient(name: "Eggs", quantity: 6)

 class ShoppingListItem: RecipeIngredient {
    var purchased = false
    var description: String {
    var output = "\(quantity) x \(name.lowercaseString)"
    output += purchased ? " ✔" : " ✘"
    return output }
 }

 var breakfastList = [
    ShoppingListItem(), ShoppingListItem(name: "Bacon"), ShoppingListItem(name: "Eggs", quantity: 6),
 ]
 breakfastList[0].name = "Orange juice"; breakfastList[0].purchased = true
 for item in breakfastList {
    print(item.description)
 }
 // 1 x orange juice ✔ 
 // 1 x bacon✘
 // 6 x eggs ✘￼
 ```

*可失败构造器* class、struct、enum (init?)

如果一个类,结构体或枚举类型的对象,在构造自身的过程中有可能失败,则为其定义一个可失败构造器,是非
常有必要的。这里所指的“失败”是指,如给构造器传入无效的参数值,或缺少某种所需的外部资源,又或是不
满足某种必要的条件等。

 > Note:
   - 可失败构造器的参数名和参数类型,不能与其它非可失败构造器的参数名,及其类型相同。
   - 构造器都不支持返回值。因为构造器本身的作用,只是为了能确保对象自身能被正确构 建。所以即使你在表明可失败构造器,失败的这种情况下,用到了 return nil 。也不要在表明可失败构造器成功 的这种情况下,使用关键字 return 。
 
 ```Swift
 struct Animal {
    let species:String
    init?(species:String){
        if species.isEmpty{
            return nil
        }
        self.species = species
    }
 }
 // someCreature 的类型为 Animal?
 let someCreature = Animal(species: "Giraffe")
 if let giraffe = someCreature{
    print(giraffe.species)
 }
 // 构造失败
 let anonymousCreature = Animal(species: "")
 if anonymousCreature == nil {
    print("The anonymous creature could not be initialized")
 }
 ```

 	- 枚举类型的可失败构造器
 		 ```Swift
 		 enum TemperatureUnit{
    		case Kelvin,Celsius,Fahrenheit
    			init?(symbol:Character){
	        		switch symbol{
	        		case "K":
			            self = .Kelvin
			        case "C":
			            self = .Celsius
			        case "F":
			            self = .Fahrenheit
			        default:
			            return nil
			        }
			    }
			}
		 let fahrenheitUnit = TemperatureUnit(symbol: "F")
		 let unknowUnit = TemperatureUnit(symbol: "A")
 		 ```
 	- 带原始值的枚举类型的可失败构造器
 		- 带原始值的枚举类型会自带一个可失败构造器 init?(rawValue:) ,该可失败构造器有一个名为 rawValue 的默认参 数,其类型和枚举类型的原始值类型一致,如果该参数的值能够和枚举类型成员所带的原始值匹配,则该构造器构 造一个带此原始值的枚举成员,否则构造失败。
 		- `enum TemperatureUnit: Character {case Kelvin = "K", Celsius = "C", Fahrenheit = "F"};`
 	- 类的可失败构造器
 		- 值类型(如结构体或枚举类型)的可失败构造器,对何时何地触发构造失败这个行为没有任何的限制。比如在前 面的例子中,结构体 Animal 的可失败构造器触发失败的行为,甚至发生在 species 属性的值被初始化以前。而 对类而言,就没有那么幸运了。类的可失败构造器只能在所有的类属性被初始化后和所有类之间的构造器之间的 代理调用发生完后触发失败行为。

 		 ```Swift
 		 class Product {
 		  	// 想要在该类中添加可失败构造器触发失败条件时,必须确保 name 属性被初始化,因此name为(String!)类型
			let name: String! 
			init?(name: String) {
				self.name = name
				if name.isEmpty { return nil } 
			}
		 }
		 if let bowTie = Product(name: "bow tie") {
			// 不需要检查 bowTie.name == nil
			print("The product's name is \(bowTie.name)"
			)
		 }
 		 ```

 	- 构造失败的传递
 		- 无论是向上代理还是横向代理,如果你代理的可失败构造器,在构造过程中触发了构造失败的行为,整个构造过程都将被立即终止,接下来任何的构造代码都将不会被执行。

 		 > Note:
 		  可失败构造器也可以代理调用其它的非可失败构造器。通过这个方法,你可以为已有的构造过程加入构 造失败的条件

 		```Swift
 		 class CartItem: Product {
			let quantity: Int!
			init?(name: String, quantity: Int) {
				super.init(name: name)
				if quantity < 1 { return nil } 
				self.quantity = quantity
			} 
		 }
		 if let twoSocks = CartItem(name: "sock", quantity: 2) { 
		 	print("Item: \(twoSocks.name), quantity: \(twoSocks.quantity)")
		 }
		 // 打印 "Item: sock, quantity: 2"

		 if let zeroShirts = CartItem(name: "shirt", quantity: 0) {
			print("Item: \(zeroShirts.name), quantity: \(zeroShirts.quantity)")
			} else {
			print("Unable to initialize zero shirts")
		 }
			// 打印 "Unable to initialize zero shirts"

		 if let oneUnnamed = CartItem(name: "", quantity: 1) {
			print("Item: \(oneUnnamed.name), quantity: \(oneUnnamed.quantity)")
			} else {
			print("Unable to initialize one unnamed product")
		 }
			// 打印 "Unable to initialize one unnamed product"
 		```

 	- 重写一个可失败构造器
 		- 用子类的可失败构造器重写基类的可失败构造器。或者你也可以用子类的非可失败构造器重写一个基类的可失败构造器。这样做的好处是,即使基类的构造器为可失败构造器,但当子类的构造器在构造过程不可能失败时,我们也可以把它修改过来。
 		- 你可以用一个非可失败构造器重写一个可失败构造器,但反过来却行不通。

 		```Swift
 		//  name 属性允许为 nil 和一个非空字符串,但不能是一个空字 符串:
			class Document {
			    var name: String?
			    // 该构造器构建了一个name属性值为nil的document对象
			    init() {}
			    // 该构造器构建了一个name属性值为非空字符串的document对象 
			    init?(name: String) {
			    if name.isEmpty { return nil }
			    self.name = name
			    }
			}

			class AutomaticallyNamedDocument: Document {
			        override init() {
			        super.init()
			        self.name = "[Untitled]"
			        }
			        override init(name: String) { super.init()
			            if name.isEmpty {
			                self.name = "[Untitled]"
			            } else {
			                self.name = name
			        }
			    }
			}
 		```

 	- 可失败构造器 init!
 		- 通常来说我们通过在 init 关键字后添加问号的方式来定义一个可失败构造器,但你也可以使用通过在 init 后面添 加惊叹号的方式来定义一个可失败构造器 (init!) ,该可失败构造器将会构建一个特定类型的隐式解析可选类型的 对象。
		- 你可以在 init? 构造器中代理调用 init! 构造器,反之亦然。 你也可以用 init? 重写 init! ,反之亦然。 你还可以 用 init 代理调用 init! ,但这会触发一个断言:是否 init! 构造器会触发构造失败?

*必要构造器*

在类的构造器前添加 required 修饰符表明所有该类的子类都必须实现该构造器:

当子类重写基类的必要构造器时,必须在子类的构造器前同样添加 required 修饰符以确保当其它类继承该子类 时,该构造器同为必要构造器。在重写基类的必要构造器时,不需要添加 override 修饰符:

 > 注意: 如果子类继承的构造器能满足必要构造器的需求,则你无需显示的在子类中提供必要构造器的实现。

 ```Swift
 class SomeClass { 
 	required init() {
 		// 在这里添加该必要构造器的实现代码 
 	}
 }
 class SomeSubclass: SomeClass { 
 	required init() {
  		// 在这里添加子类必要构造器的实现代码 
	}
 }
 ```
*通过闭包和函数来设置属性的默认值*

如果某个存储型属性的默认值需要特别的定制或准备,你就可以使用闭包或全局函数来为其属性提供定制的默认
值。每当某个属性所属的新类型实例创建时,对应的闭包或函数会被调用,而它们的返回值会当做默认值赋值给
这个属性。

这种类型的闭包或函数一般会创建一个跟属性类型相同的临时变量,然后修改它的值以满足预期的初始状态,最
后将这个临时变量的值作为属性的默认值进行返回。

 > Note: 
  如果你使用闭包来初始化属性的值,请记住在闭包执行时,实例的其它部分都还没有初始化。这意味着你不能够 在闭包里访问其它的属性,就算这个属性有默认值也不允许。同样,你也不能使用隐式的 self 属性,或者调用 其它的实例方法。

 ```Swift
 struct CheckerBoard {
    let boardColors:[Bool] = {
        var temporaryBoard = [Bool]()
        var isBlack = false
        for i in 1...10{
            for j in 1...10 {
                temporaryBoard.append(isBlack)
                isBlack = !isBlack
            }
            isBlack = !isBlack
        }
        return temporaryBoard
    }()
    func squareIsBlackAtRow(row:Int,column:Int) -> Bool{
        return boardColors[(row * 10) + column]
    }
 }
 let board = CheckerBoard()
 // 函数外部参数第一个不显示，第二个显示
 board.squareIsBlackAtRow(0, column: 1)
 // 输出 "true"
 print(board.squareIsBlackAtRow(9, column: 9))
 // 输出 "false"
 ```
