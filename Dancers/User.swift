//
//  User.swift
//  Dancers
//
//  Created by 田山　由理 on 2017/01/03.
//  Copyright © 2017年 Yuri Tayama. All rights reserved.
//

import ObjectMapper

class User: Mappable {
    
    var id        :String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map){
        id            <- map["id"]
    }
}
