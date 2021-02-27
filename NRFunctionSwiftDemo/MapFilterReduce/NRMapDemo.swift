//
//  NRMapDemo.swift
//  NRFunctionSwiftDemo
//
//  Created by 王文涛 on 2021/1/7.
//

import Foundation

// 写一个函数，传入一个数组作为参数
// 然后返回一个新的数组，新数组的值是传入数组的每项值加一
func increment(array: [Int]) -> [Int] {
    var result = [Int]()
    for i in array {
        result.append(i + 1)
    }
    return result
}

// 写一个函数，传入一个数组作为参数
// 然后返回一个新的数组，新数组的值是传入数组的每项值的二倍
func double(array: [Int]) -> [Int] {
    var result = [Int]()
    for i in array {
        result.append(i * 2)
    }
    return result
}

// 计算函数，多传入一个转换函数
func compute(array: [Int], transform: (Int)-> Int) -> [Int] {
    var result = [Int]()
    for x in array {
        result.append(transform(x))
    }
    return result
}

func compute(array: [Int], transform: (Int)-> Bool) -> [Bool] {
    var result = [Bool]()
    for x in array {
        result.append(transform(x))
    }
    return result
}

// double函数的另一个版本
func double2(array: [Int]) -> [Int] {
    return compute(array: array) { (x) -> Int in
        x * 2
    }
}

// 写一个函数，传入一个数组作为参数
// 函数返回一个新的数组，对应传入数组的值是否是偶数的布尔值
func isEven(array: [Int]) -> [Bool] {
    return compute(array: array) { $0 % 2 == 0 }
}

// 使用泛型做通用的转换
func genericCompute<T>(array: [Int], tranform: (Int) -> T) -> [T] {
    var result: [T] = []
    for x in array {
        result.append(tranform(x))
    }
    return result
}

// 更一般的转换，数组元素的类型也可以用泛型
func map<Element, T>(array: [Element], tranform: (Element) -> T) -> [T] {
    var result = [T]()
    for x in array {
        result.append(tranform(x))
    }
    return result
}

// 使用map重新定义genericCompute函数
func genericCompute2<T>(array: [Int], tranform: (Int) -> T) -> [T] {
    return map(array: array, tranform: tranform)
}

// 扩展Array
extension Array {
    func nr_map<T>(_ transform: (Element) -> T) -> [T] {
        var result = [T]()
        for i in self {
            result.append(transform(i))
        }
        return result
    }
}
