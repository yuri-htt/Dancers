//
//  Enums.swift
//  Dancers
//
//  Created by 田山　由理 on 2016/12/31.
//  Copyright © 2016年 Yuri Tayama. All rights reserved.
//

import Foundation
import UIKit

enum ColorPattern:String {
    case Blue   = "Blue"
    case Orange = "Orange"
    case Black  = "Black"
    
    func makeBaseColor() -> UIColor {
        
        var baseColor:UIColor
        
        switch  self {
        case .Blue:
            baseColor = UIColor(red: 32/255, green: 100/255, blue: 163/255, alpha: 1.0)
        case .Orange:
            // FIXME: コード値の分母修正（2017/01/04）
            baseColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.85)
            // baseColor = UIColor(red: 255/250, green: 255/250, blue: 255/250, alpha: 0.85)
        case .Black:
            // FIXME: コード値の分母修正（2017/01/04）
            baseColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.85)
            // baseColor = UIColor(red: 255/250, green: 255/250, blue: 255/250, alpha: 0.85)
        }
        return baseColor
    }
    
    func makeGradation() -> [Any] {
        
        var startColor:CGColor
        var endColor:CGColor
        
        switch self {
        case .Blue:
            startColor = UIColor(red: 30/255, green: 255/255, blue: 0/255, alpha: 0.15).cgColor
            endColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.25).cgColor

        case .Orange:
            // FIXME: コード値の分母修正（2017/01/04）
            startColor = UIColor(red: 228/255, green: 173/255, blue: 131/255, alpha: 1.0).cgColor
            // startColor = UIColor(red: 228/250, green: 173/250, blue: 131/250, alpha: 1.0).cgColor
            endColor = UIColor(red: 220/255, green: 73/255, blue: 73/255, alpha: 0.87).cgColor
        case .Black:
            // FIXME: コード値の分母修正（2017/01/04）
            startColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.59).cgColor
            // startColor = UIColor(red: 0/250, green: 0/250, blue: 0/250, alpha: 0.59).cgColor
            endColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0).cgColor
        }
        return [startColor, endColor]
    }
    
    static func getColorType(colorType:String) -> ColorPattern {
        return ColorPattern(rawValue: colorType) ?? ColorPattern.Blue
    }
}
