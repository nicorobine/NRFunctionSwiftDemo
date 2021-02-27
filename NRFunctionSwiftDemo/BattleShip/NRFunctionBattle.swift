//
//  NRFunctionBattle.swift
//  NRFunctionSwiftDemo
//
//  Created by 王文涛 on 2020/12/29.
//

import Foundation

// 定义一个区域函数，便于理解
// swift的函数式一等值
fileprivate typealias Region = (NRPosition) -> Bool

// 定义一个圆，返回圆的区域
fileprivate func circle(radius: NRDistance) -> Region {
    return { point in point.length <= radius }
}

// 定义一个指定中心的区域
fileprivate func circle2(radius: NRDistance, center: NRPosition) -> Region {
    return { point in point.minus(center).length < radius }
}

// 定义一个转换函数，避免写多个像circle2类的函数
fileprivate func shift(_ region: @escaping Region, by offset: NRPosition) -> Region {
    return { point in region(point.minus(offset))}
}

// 反转区域
fileprivate func invert(_ region: @escaping Region) -> Region {
    return { point in !region(point) }
}

// 区域交集
fileprivate func intersect(_ region: @escaping Region, with other: @escaping Region) -> Region {
    return { point in region(point) && other(point) }
}

// 并集区域
fileprivate func union(_ region: @escaping Region, with other: @escaping Region) -> Region {
    return { point in region(point) || region(point) }
}

// 区域相减
fileprivate func subtract(_ region: @escaping Region, from original: @escaping Region) -> Region {
    return intersect(original, with: invert(region))
}

fileprivate extension NRShip {
    // 是否可以安全的射击
    func canSafelyEngage(ship target: NRShip, friendly: NRShip) -> Bool {
        let rangeRegion = subtract(circle(radius: unsafeRange), from: circle(radius: firingRange))
        let firingRegion = shift(rangeRegion, by: positation)
        let friendlyRegion = shift(circle(radius: unsafeRange), by: friendly.positation)
        let resultRegion = subtract(friendlyRegion, from: firingRegion)
        return resultRegion(target.positation)
    }
}

