//
//  SettingsLauncher.swift
//  Dancers
//
//  Created by 田山　由理 on 2017/01/02.
//  Copyright © 2017年 Yuri Tayama. All rights reserved.
//

import UIKit

class SettingsLauncher:NSObject {
    
    let blackView = UIView()
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = sideMenuColor
        cv.isUserInteractionEnabled = true
        return cv
    }()
    
    func showSettings() {
        
        if let window = UIApplication.shared.keyWindow {
            
            collectionView.frame = CGRect(x: -300, y: 0, width: 300, height: window.frame.height)
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.isUserInteractionEnabled = true
            blackView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(handleDismiss)))
            blackView.frame = window.frame
            blackView.alpha = 0
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
        
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping:1, initialSpringVelocity:1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: 0, width: 300, height: window.frame.height)
                
            }, completion: nil)
        }
    }
    
    func handleDismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
        })
    }
    
    override init() {
        super.init()
    }
    
    func tapped(_ sender: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            //collectionView.frame = CGRect(x: -300, y: 0, width: 300, height: UIApplication.shared.keyWindow?.frame.height)
        })
    }
}

