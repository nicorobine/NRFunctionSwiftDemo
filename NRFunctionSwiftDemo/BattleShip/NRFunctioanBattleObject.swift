//
//  NRFunctioanBattleObject.swift
//  NRFunctionSwiftDemo
//
//  Created by 王文涛 on 2020/12/30.
//

import Foundation

fileprivate struct Region {
    let lookup: (NRPosition) -> Bool
}

fileprivate extension Region {
    func shift(_ offset: NRPosition) -> Region {
        return Region { (point) -> Bool in
            lookup(point.minus(offset))
        }
    }
}

fileprivate extension Region {
    static func circle(radius: NRDistance) -> Region {
        return Region { (point) -> Bool in
            point.length <= radius
        }
    }
}

fileprivate extension Region {
    func invert() -> Region {
        return Region { (point) -> Bool in
            !lookup(point)
        }
    }
}

fileprivate extension Region {
    func intersect(with other: Region) -> Region {
        return Region { (point) -> Bool in
            lookup(point) && other.lookup(point)
        }
    }
}

fileprivate extension Region {
    func union(with other: Region) -> Region {
        return Region { (point) -> Bool in
            lookup(point) || other.lookup(point)
        }
    }
}

fileprivate extension Region {
    func subtract(with other: Region) -> Region {
        return Region { (point) -> Bool in
            union(with: other.invert()).lookup(point)
        }
    }
}

fileprivate extension NRShip {
    func canSafelyEngage(ship target: NRShip, friendly: NRShip) -> Bool {
        let rangeRegion = Region.circle(radius: firingRange).subtract(with: Region.circle(radius: unsafeRange))
        let firingRegion = rangeRegion.shift(positation)
        let friendlyRegion = Region.circle(radius: friendly.unsafeRange).shift(friendly.positation)
        let resultRegion = firingRegion.subtract(with: friendlyRegion)
        return resultRegion.lookup(target.positation)
    }
}

fileprivate func test() {
    let ship = NRShip(positation: NRPosition(x: 10, y: 10), firingRange: 100, unsafeRange: 20)
    let target = NRShip(positation: NRPosition(x: 40, y: 40), firingRange: 100, unsafeRange: 20)
    let friend = NRShip(positation: NRPosition(x: 50, y: 50), firingRange: 100, unsafeRange: 20)
    
    print("can safe engate: \(ship.canSafelyEngage(ship: target, friendly: friend))")
}
