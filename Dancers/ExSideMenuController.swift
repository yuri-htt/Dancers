//
//  ExSideMenuController.swift
//  Dancers
//
//  Created by 田山　由理 on 2017/01/02.
//  Copyright © 2017年 Yuri Tayama. All rights reserved.
//

import UIKit

import UIKit

class ExSlideMenuController : SlideMenuController {
    
    override func isTagetViewController() -> Bool {
        if let vc = UIApplication.topViewController() {
            if vc is ViewController  {
                return true
            }
        }
        return false
    }
    
    override func track(_ trackAction: TrackAction) {
        switch trackAction {
        case .leftTapOpen:
            print("TrackAction: left tap open.")
        case .leftTapClose:
            print("TrackAction: left tap close.")
        case .leftFlickOpen:
            print("TrackAction: left flick open.")
        case .leftFlickClose:
            print("TrackAction: left flick close.")
        case .rightTapOpen:
            print("TrackAction: right tap open.")
        case .rightTapClose:
            print("TrackAction: right tap close.")
        case .rightFlickOpen:
            print("TrackAction: right flick open.")
        case .rightFlickClose:
            print("TrackAction: right flick close.")
        }
    }
}

