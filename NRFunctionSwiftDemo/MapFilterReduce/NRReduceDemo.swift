//
//  NRReduceDemo.swift
//  NRFunctionSwiftDemo
//
// Reduce：是给定一个初始值inital: T，
// 和一个转换函数 (T, O) -> T（将初始值类型的值和另一个类型的值进行组合，返回初始值类型的值）
// 然后返回初始值类型的函数
// 函数的类型为 (initial: T, combine: (T, O) -> T) -> T
//
//  Created by 王文涛 on 2021/1/15.
//

import Foundation

func sum(integers: [Int]) -> Int {
    var result: Int = 0
    for i in integers {
        result += i
    }
    return result
}

func product(integers: [Int]) -> Int {
    var result: Int = 1
    for i in integers {
        result *= i
    }
    return result
}

func concatenate(strings: [String]) -> String {
    var result = ""
    for s in strings {
        result += s
    }
    return result
}

func prettyPrint(strings: [String]) -> String {
    var result: String = "Entries in the array xs:\n"
    for s in strings {
        result = " " + result + s + "\n"
    }
    return result
}

// 这些函数有什么共同点呢？它们都将变量 result 初始化为某个值。随后对输入数组的每一项进行遍历，
// 最后以某种方式更新结果。为了定义一个可以体现所需类型的泛型函数，我们需要对两份信息进行抽象：
// 赋给 result 变量的初始值，和用于在每一次循环中更新 result 的函数。

extension Array {
    func nr_reduce<T>(_ initial: T, combine:(T, Element) -> T) -> T {
        var result = initial
        for x in self {
            result = combine(result, x)
        }
        return result
    }
}

func sumUsingReduce(integers: [Int]) -> Int {
    return integers.nr_reduce(0) { $0 + $1 }
}

func productUsingReduce(integers: [Int]) -> Int {
    return integers.nr_reduce(1, combine: { $0 * $1 })
}

func concatUsingReduce(strings: [String]) -> String {
    return strings.nr_reduce("") { $0 + $1 }
}

// 假设有一个数组，他的每一项都是数组
// 将这个数组展开为一个单一的数组
func flatten<T>(_ xss: [[T]]) -> [T] {
    var result: [T] = []
    for xs in xss {
        for x in xs {
            result.append(x)
        }
    }
    return result
}

func flattenUsingReduce<T>(_ xss: [[T]]) -> [T] {
    xss.reduce([]) { (result, xs) -> [T] in
        result + xs
    }
}

extension Array {
    func mapUsingReduce<T>(_ transform: (Element) -> T) -> [T] {
        return self.nr_reduce([]) { result, x in
            return result + [transform(x)]
        }
    }
}

extension Array {
    func filterUsingReduce(_ includeElement: (Element) -> Bool) -> [Element] {
        return self.reduce([]) { result, x in
            return includeElement(x) ? result + [x] : result
        }
    }
}
