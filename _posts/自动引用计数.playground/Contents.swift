//: Playground - noun: a place where people can play

import Cocoa

class Employee {
    var no:Int
    var name:String
    var job:String
    var salary:Double
    
    init(no:Int,name:String,job:String,salary:Double){
        self.no = no;
        self.name = name;
        self.job = job;
        self.salary = salary;
        print("员工\(name)已经成功构造出来了")
    }
    deinit{
        print("员工\(name)已经成功析构")
    }
}

var reference1: Employee?
var reference2: Employee?
var reference3: Employee?

//变量ref1与对象建立“强引用”关系，“强引用”关系能够保证对象在内存中不被释放，这时候它的引用计数是1。
 reference1 = Employee(no: 7698, name: "Blake", job: "SaleMan", salary: 1600)
 reference2 = reference1
 reference3 = reference1

reference1 = nil
reference2 = nil
reference3 = nil

var ref:Employee = Employee(no: 1, name: "2", job: "32", salary: 123)
//ref as! Employee = nil // 为值类型不是引用类型
