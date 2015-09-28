//: Playground - noun: a place where people can play

import Cocoa

// 抛出错误符合ErrorType协议
enum AwfulError: ErrorType {
    case Bad
    case Worse
    case Terrible
}

// 然后如果一个可能抛出一个或多个错误的函数或方法会被throws关键字标记
func doDangerousStuff() throws -> NSObject {
    // If something bad happens throw the error:
    throw AwfulError.Bad
    
    // If something worse happens, throw another error:
    throw AwfulError.Worse
    
    // If something terrible happens, you know what to do:
    throw AwfulError.Terrible
    
    // If you made it here, you can return:
    return NSObject()
}

//// 为了捕获错误，新型的do-catch语句出现了
//do {
//    let theResult = try obj.doDangerousStuff()
//}
//catch AwfulError.Bad {
//    // Deal with badness.
//}
//catch AwfulError.Worse {
//    // Deal with worseness.
//}
//catch AwfulError.Terrible {
//    // Deal with terribleness.
//}
//catch ErrorType {
//    // Unexpected error!
//}

