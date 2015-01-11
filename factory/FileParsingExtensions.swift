//
//  FileParsingExtensions.swift
//  factory
//
//  Created by Zach Jaquish on 1/11/15.
//  Copyright (c) 2015 Zach Jaquish. All rights reserved.
//

import UIKit

extension UIColor {
    func toString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: nil)
        return "\(r),\(g),\(b)"
    }
    
    convenience init(_ string: String) {
        let stringParts = string.componentsSeparatedByString(",") as [String]
        let floatParts = stringParts.map { CGFloat(($0 as NSString).floatValue) }
        assert(floatParts.count == 3)
        self.init(red:floatParts[0], green: floatParts[1], blue: floatParts[2], alpha: 1.0)
    }
}