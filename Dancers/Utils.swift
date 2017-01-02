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
    
    class func checkResponse(_ response : DataResponse<Data> ){
        if let response = response.response , response.statusCode == 401 {
            
            print("401 Unauth")
            
        }
    }
    
    
}
