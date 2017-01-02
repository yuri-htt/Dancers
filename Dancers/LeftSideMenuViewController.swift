//
//  LeftSideMenuViewController.swift
//  Dancers
//
//  Created by 田山　由理 on 2017/01/02.
//  Copyright © 2017年 Yuri Tayama. All rights reserved.
//

import UIKit

enum LeftMenu: Int {
    case main = 0
    case swift
    case java
    case go
    case nonMenu
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftSideMenuViewController: UIViewController, LeftMenuProtocol {

    var mainViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .main:
            print("")
            //self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .swift:
            print("")
            //self.slideMenuController()?.changeMainViewController(self.swiftViewController, close: true)
        case .java:
            print("")
            //self.slideMenuController()?.changeMainViewController(self.javaViewController, close: true)
        case .go:
            print("")
            //self.slideMenuController()?.changeMainViewController(self.goViewController, close: true)
        case .nonMenu:
            print("")
            //self.slideMenuController()?.changeMainViewController(self.nonMenuViewController, close: true)
        }
    }

}
