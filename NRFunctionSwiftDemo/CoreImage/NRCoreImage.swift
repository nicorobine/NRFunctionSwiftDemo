//
//  NRCoreImage.swift
//  NRFunctionSwiftDemo
//
//  Created by 王文涛 on 2021/1/5.
//

import Foundation
import CoreImage
import UIKit

typealias Filter = (CIImage) -> CIImage

func blur(radius: Double) -> Filter {
    return { image in
        let parameters: [String: Any] = [
            kCIInputRadiusKey: radius,
            kCIInputImageKey: image
        ]
        guard let filter = CIFilter(name: "CIGaussianBlur", parameters: parameters) else {
            fatalError()
        }
        guard let outputImage = filter.outputImage else {
            fatalError()
        }
        return outputImage
    }
}

func generate(color: UIColor) -> Filter {
    return {_ in
        let parameters = [
            kCIInputColorKey: CIColor(cgColor: color.cgColor)
        ]
        guard let filter = CIFilter(name: "CIConstantColorGenerator", parameters: parameters) else {
            fatalError()
        }
        guard let outputImage = filter.outputImage else {
            fatalError()
        }
        return outputImage
    }
}

func compositeSourceOver(overlaying: CIImage) -> Filter {
    return { image in
        let parameters = [
            kCIInputBackgroundImageKey: image,
            kCIInputImageKey: overlaying,
        ]
        
        guard let fileter = CIFilter(name: "CISourceOverCompositing", parameters: parameters) else {
            fatalError()
        }
        guard let outputImage = fileter.outputImage else {
            fatalError()
        }
        return outputImage.cropped(to: image.extent)
    }
}

func overlay(color: UIColor) -> Filter {
    return { image in
        let overlay = generate(color: color)(image).cropped(to: image.extent)
        return compositeSourceOver(overlaying: overlay)(image)
    }
}

func compose(filter filter1: @escaping Filter, with filter2: @escaping Filter) -> Filter {
    return { image in
        filter2(filter1(image))
    }
}

infix operator >>>

func >>>(filter1: @escaping Filter, filter2: @escaping Filter) -> Filter {
    return { image in
        filter2(filter1(image))
    }
}
