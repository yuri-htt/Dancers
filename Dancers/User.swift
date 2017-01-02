//
//  Model.swift
//  Dancers
//
//  Created by 田山　由理 on 2017/01/02.
//  Copyright © 2017年 Yuri Tayama. All rights reserved.
//

import ObjectMapper

class User: Mappable {
    
    var id        :Int?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map){
        id            <- map["id"]
    }
}
