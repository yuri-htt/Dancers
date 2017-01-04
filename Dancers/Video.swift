//
//  Video.swift
//  Dancers
//
//  Created by 田山　由理 on 2017/01/03.
//  Copyright © 2017年 Yuri Tayama. All rights reserved.
//

import ObjectMapper

class VideoMap: Mappable {
    
    var videos:[Video]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map){
        videos <- map["video"]
    }
}

class Video: Mappable {
    
    var create_date:String?
    var creator:String?
    var description:String?
    var embedded_url:String?
    var favorite_counter:String?
    var id :String?
    var length_seconds:String?
    var thumbnail_url:String?
    var title:String?
    var view_counter:String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map){
        create_date      <- map["create_date"]
        creator          <- map["creator"]
        description      <- map["description"]
        embedded_url     <- map["embedded_url"]
        favorite_counter <- map["favorite_counter"]
        id               <- map["id"]
        length_seconds   <- map["length_seconds"]
        thumbnail_url    <- map["thumbnail_url"]
        title            <- map["title"]
        view_counter     <- map["view_counter"]
    }
}
