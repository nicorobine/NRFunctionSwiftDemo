//
//  NRBattle.swift
//  NRFunctionSwiftDemo
//
//  Created by 王文涛 on 2020/12/29.
//

import Foundation

typealias NRDistance = Double

// 位置
struct NRPosition {
    var x: Double
    var y: Double
}

extension NRPosition {
    // 位置是否在相对于远点的范围内
    func within(range: NRDistance) -> Bool {
        return sqrt(x * x + y * y) <= range
    }
}

struct NRShip {
    var positation: NRPosition
    var firingRange: NRDistance
    var unsafeRange: NRDistance
}

extension NRShip {
    // 只考虑安全范围和射击范围
    func canEngage(ship target: NRShip) -> Bool {
        let dx = target.positation.x - positation.x
        let dy = target.positation.y - positation.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange && targetDistance > unsafeRange
    }
    
    // 还要考虑友方船
    func canEngate(ship target: NRShip, friendly: NRShip) -> Bool {
        let dx = target.positation.x - positation.x
        let dy = target.positation.y - positation.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        let friendlyDx = friendly.positation.x - target.positation.x
        let friendlyDy = friendly.positation.y - target.positation.y
        let friendlyDistance = sqrt(friendlyDx * friendlyDx + friendlyDy * friendlyDy)
        return targetDistance <= firingRange && targetDistance > unsafeRange && friendlyDistance > unsafeRange
    }
    
    // 使用辅助方法
    func canEngage2(ship target: NRShip, friendly: NRShip) -> Bool {
        let targetDistance = target.positation.minus(positation).length
        let friendlyDistance = friendly.positation.minus(target.positation).length
        return targetDistance <= firingRange && targetDistance > unsafeRange && friendlyDistance > unsafeRange
    }
}

extension NRPosition {
    func minus(_ p: NRPosition) -> NRPosition {
        return NRPosition(x: x - p.x, y: y - p.y)
    }
    
    var length: Double {
        return sqrt(x * x + y * y)
    }
}


