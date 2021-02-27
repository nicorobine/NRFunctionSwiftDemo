//
//  NRCityDemo.swift
//  NRFunctionSwiftDemo
//
//  Created by 王文涛 on 2021/1/15.
//

import Foundation

struct NRCity {
    let name: String
    let population: Int
}

let paris = NRCity(name: "Paris", population: 2241)
let madrid = NRCity(name: "Madrid", population: 3165)
let amsterdam = NRCity(name: "Amsterdam", population: 827)
let berlin = NRCity(name: "Berin", population: 3562)

let cities = [paris, madrid, amsterdam, berlin]

extension NRCity {
    func scalingPopulation() -> NRCity {
        return NRCity(name: name, population: population * 1000)
    }
}

extension NRCity {
    func nr_test() {
        let rs = cities.nr_fileter { (city) -> Bool in
            city.population > 1000
        }.reduce("City: Population") { (result, c) -> String in
            return result + "\n" + "\(c.name):\(c.population)"
        }
        print("rs: \(rs)")
    }
}

// 柯里化
// 将(A, B), C柯里化为 A, B, C
func curry<A,B,C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> (C) {
    return { x in { y in f(x, y)}}
}


