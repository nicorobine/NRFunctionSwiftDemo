//
//  NRFilterDemo.swift
//  NRFunctionSwiftDemo
//
//  Created by 王文涛 on 2021/1/15.
//

import Foundation

let exampleFiles = ["README.md", "HelloWord.swift", "FlappyBird.swift"]

func getSwfitFiles(in files:[String]) -> [String] {
    var result: [String] = []
    for file in files {
        if file.hasSuffix(".swift") {
            result.append(file)
        }
    }
    return result
}

extension Array {
    func nr_fileter(_ includeElement:(Element) -> Bool) -> [Element] {
        var result: [Element] = []
        for x in self where includeElement(x) {
            result.append(x)
        }
        return result;
    }
}



