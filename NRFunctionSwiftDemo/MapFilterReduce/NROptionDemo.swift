//
//  NROptionDemo.swift
//  NRFunctionSwiftDemo
//
//  Created by 王文涛 on 2021/2/27.
//

import Foundation

/***************可选值****************/

let citiesMap = ["Pairs": 2241, "Madrid": 3165, "Amsterdam": 827, "Berlin": 3562]

// 可选绑定
fileprivate func test() {
    if let madridPopulation = citiesMap["Madrid"] {
        print("The population of Madrid is \(madridPopulation)")
    } else {
        print("Unknown city: Madrid")
    }
}

// 自定一个??操作符
// 这里的定义有一个问题：
// 如果 defaultValue 的值是通过某个函数或者表达式得到的，那么无论可选值是否为nil，
// defaultValue 都会被求值，这是不合理的，通常只有可选参数值为nil的时候 defaultValue才进行求值
infix operator ??!
func ??!<T>(optional: T?, defaultValue: T) -> T {
    if let x = optional {
        return x
    }
    return defaultValue
}

// 改进方案
// 能够结果可选值为不为nil的时候 defaultValue 如果是函数或者表达式时被计算的问题，
// 但是使用起来不方便，如：test1
infix operator ??!!
func ??!!<T>(optional: T?, defaultValue: () -> T) -> T {
    if let x = optional {
        return x
    } else {
        return defaultValue()
    }
}

fileprivate func text1() {
    let cache = ["test.swift": 1000]
    let defaultValue = 2000;
    _ = cache["hello.swift"] ??!! { defaultValue }
}

// 最终方案
// Swift 标准库中的定义通过使用 Swift 的 aotoclosure 类型标签来避开显式闭包的需求
// 它会在所需要的闭包中隐式的将参数封装到 ?? 运算符
infix operator ??!!!

fileprivate func ??!!!<T>(optional: T?, defaultValue:@autoclosure () throws -> T) rethrows -> T {
    if let x = optional {
        return x
    }
    return try defaultValue()
}

/***************可选链****************/

fileprivate struct NROrder {
    let orderNum: Int
    let person: NRPerson?
}

fileprivate struct NRPerson {
    let name: String
    let address: NRAddress?
}

fileprivate struct NRAddress {
    let streetName: String
    let city: String
    let state: String?
}

fileprivate func test2() {
    let order = NROrder(orderNum: 42, person: nil)
    
    // 可选绑定
    if let person = order.person {
        if let address = person.address {
            if let state = address.state {
                print("Got a state: \(state)")
            }
        }
    }
    
    // 可选链
    if let state = order.person?.address?.state {
        print("Got a state: \(state)")
    } else {
        print("Unkonwn person, adress, or state")
    }
}


/***************分支上的可选值****************/

fileprivate func test3() {
    let madridPopulation = citiesMap["Madrid"]
    switch madridPopulation {
    case 0?:
        print("Nobody in Madrid")
    case (1..<1000)?:
        print("Less than a millon in Madrid")
    case let x?:
        print("\(x) pepple in Madrid")
    case nil:
        print("We don't knw about Madrid")
    }
}

/*************** guard ****************/

fileprivate func test4() {
    // 必须return
    guard let madridPopulation = citiesMap["Madrid"] else {
        print("We don't knw about Madrid")
        return
    }
    print("The population of Madrid is \(madridPopulation)")
}

/*************** 可选映射 ****************/

fileprivate extension Optional {
    func nr_map<U>(_ transform: (Wrapped) -> U) -> U? {
        guard let x = self else { return nil }
        return transform(x)
    }
}

/*************** flatmap ****************/

fileprivate func add1(_ optionalX: Int?, _ optioalY: Int?) -> Int? {
    if let x = optionalX {
        if let y = optioalY {
            return x + y
        }
    }
    return nil
}

fileprivate func add2(_ optionalX: Int?, _ optioalY: Int?) -> Int? {
    if let x = optionalX, let y = optioalY {
        return x + y
    }
    return nil
}

fileprivate func add3(_ optionalX: Int?, _ optioalY: Int?) -> Int? {
    guard let x = optionalX, let y = optioalY else { return nil }
    return x + y
}

let captialsMap = [
    "France": "Paris",
    "Spain": "Madrid",
    "The Netherlands": "Amsterddam",
    "Belguim": "Brussels"
]

fileprivate func populationOfCapital1(country: String) -> Int? {
    guard let captial = captialsMap[country], let population = citiesMap[captial] else { return nil }
    return population * 1000
}

// flatMap自定义实现
fileprivate extension Optional {
    func nr_flatMap<U>(_ transform: (Wrapped) throws -> U?) rethrows -> U? {
        guard let x = self else { return nil }
        return try transform(x)
    }
}

fileprivate func add4(_ optionalX: Int?, _ optioalY: Int?) -> Int? {
    return optionalX.flatMap { x in
        optioalY.flatMap { y in
            return x + y
        }
    }
}

fileprivate func populationOfCapital2(country: String) -> Int? {
    return captialsMap[country].flatMap { captial in
        return citiesMap[captial].flatMap { population in
            return population * 1000
        }
    }
}

fileprivate func populationOfCapital3(country: String) -> Int? {
    captialsMap[country].flatMap { captial in
        citiesMap[captial]
    }.flatMap { population in
        return population * 1000
    }
}

