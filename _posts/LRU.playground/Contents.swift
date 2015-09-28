//: Playground - noun: a place where people can play

import Cocoa

// ? 为可选类型
//class Node<K,V>{
//    var previous:Node?
//    var next:Node?
//    var key:K!
//    var value:V?
//    init(key:K,value:V?){
//        self.key = key
//        self.value = value
//    }
//}
//
//class LinkList<K,V> {
//    var head:Node<K,V>?
//    var tail:Node<K,V>?
//
//    init(){
//
//    }
//
//}

class HashTable <K:Hashable,V> {
    private var values:[V?]
    
    init(size:Int){
        values = [V?](count: size, repeatedValue: nil)
    }
    
    func push(key:K,value:V?){
        values[key.hashValue] = value
    }
    
    subscript(key:K) -> V?{
        get {
            return values[key.hashValue]
        }set{
            push(key, value: newValue)
        }
    }
}