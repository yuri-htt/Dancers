//
//  Model.swift
//  Dancers
//
//  Created by 田山　由理 on 2017/01/01.
//  Copyright © 2017年 Yuri Tayama. All rights reserved.
//

import UIKit
import RealmSwift

class RUser: Object {

    dynamic var name      :String = ""
    dynamic var id        :Int = 0
    dynamic var colorType :String = "Blue"
    
}
