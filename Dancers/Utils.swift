//
//  Utils.swift
//  Dancers
//
//  Created by 田山　由理 on 2017/01/02.
//  Copyright © 2017年 Yuri Tayama. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import Alamofire

class Utils {
    
    class func checkResponse(_ response : DataResponse<Data> ) {
        if let response = response.response , response.statusCode == 401 {
            print("401 Unauth")

        }
    }
    
    class func convertSec(seconds:String) -> String {
        var displayTime:String = ""

        // FIXME: ロジックの修正（2017/01/04）
        let s: Int = Int(seconds)! % 60
        let m: Int = Int(seconds)! / 60 % 60
        let h: Int = Int(seconds)! / 3600

        // ケース①（460秒を、07:40と表示したいケース）
        if h > 0 {
            displayTime += String(format: "%02d:", h)
        }
        if m > 0 {
            displayTime += String(format: "%02d:", m)
        }
        if s > 0 {
            displayTime += String(format: "%02d", s)
        }

        // ケース②（460秒を、00:07:40と表示したいケース）
        // 個人的にはこっちな気がする（その場合、変数displayTimeは不要で、そのままreturnしてOK）
        //displayTime = String(format: "%02d:%02d:%02d", h, m, s)

        return displayTime
    }
    
}
