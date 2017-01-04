//
//  User.swift
//  Dancers
//
//  Created by 田山　由理 on 2017/01/03.
//  Copyright © 2017年 Yuri Tayama. All rights reserved.
//

import ObjectMapper

class User: Mappable {
    
    // FIXME: 無駄な空白の削除（2017/01/04）
    var id :String?
    // var id        :String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map){
        // FIXME: 無駄な空白の削除（2017/01/04）
        id <- map["id"]
        // id            <- map["id"]
    }
}
