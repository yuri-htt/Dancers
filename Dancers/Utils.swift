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
        
        let displayTime:String
        
        let hour = Int(seconds)! / 3600
        let min = Int(seconds)! % 3600 / 60
        let sec = Int(seconds)! - (hour * 3600 + min * 60)
        
        if hour > 0 {
            displayTime = String(hour) + ":" + String(min) + ":" + String(sec)
        } else if min > 0 {
            displayTime = String(min) + ":" + String(sec)
        } else {
            displayTime = String(sec)
        }
        return displayTime
    }
    
}
