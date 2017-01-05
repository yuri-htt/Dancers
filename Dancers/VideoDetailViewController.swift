//
//  VideoDetailViewController.swift
//  Dancers
//
//  Created by 田山　由理 on 2017/01/05.
//  Copyright © 2017年 Yuri Tayama. All rights reserved.
//

import UIKit
import RealmSwift

enum ExpandBtnStatus {
    case opened
    case closed
}

class VideoDetailViewController:UIViewController, UITableViewDataSource, UITableViewDelegate {

    fileprivate var expandBtnState: ExpandBtnStatus = .closed
    var colorType:ColorPattern = .Blue
    var video:Video?
    
    @IBOutlet weak var backNavBtn: UIBarButtonItem!
    @IBOutlet weak var videoDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setColors()
        setCellHeight()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setColors() {
        
        let realm = try! Realm()
        let rUser = realm.objects(RUser.self)
        for user in rUser {
            self.colorType = ColorPattern.getColorType(colorType: user.colorType)
        }
        
        self.view.backgroundColor = self.colorType.makeBaseColor()
        self.videoDetailTableView.backgroundColor = UIColor.clear
        
        let layer = CAGradientLayer()
        var gradiationColors:[Any] = []
        gradiationColors = self.colorType.makeGradation()
        layer.colors = gradiationColors
        layer.frame = CGRect(x: 0, y: 76 , width: self.view.frame.size.height, height: self.view.frame.size.height)
        self.view.layer.insertSublayer(layer, at: 0)
        
    }
    
    func setCellHeight() {
        
        self.videoDetailTableView.estimatedRowHeight = 285
        self.videoDetailTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 170
        default:
            return 100
        }
    }
    
    @IBAction func didPressbackNavBtn(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoDetailCell", for: indexPath)  as! VideoDetailCell
            cell.backgroundColor = UIColor.clear
            cell.videoTitleLabel.text = self.video?.title
            cell.favoriteCountLabel.text = self.video?.favorite_counter
            cell.viewCountLabel.text = self.video?.view_counter
            cell.creatorNameLabel.text = self.video?.creator
            if let totalSec = self.video?.length_seconds {
                cell.playbackTimeLabel.text = Utils.convertSec(seconds: totalSec)
            }
            cell.descriptionLabel.text = self.video?.description
            
            cell.expandBtn.addTarget(self, action: #selector(VideoDetailViewController.expandBtnTapped(_:)), for: .touchUpInside)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListSCell", for: indexPath)  as! VideoListSCell
            cell.backgroundColor = UIColor.clear
            return cell
        }
    }
    
    func expandBtnTapped(_ sender: UIButton) {
        
        if self.expandBtnState == .closed {
            self.expandBtnState = .opened
            let upperAngle:CGFloat = CGFloat(180 * M_PI / 180)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                sender.transform = CGAffineTransform(rotationAngle: upperAngle)
            }, completion: nil)
        } else {
            self.expandBtnState = .closed
            let underAngle:CGFloat = CGFloat(-180 * M_PI / 180)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                sender.transform = CGAffineTransform(rotationAngle: underAngle)
            }, completion: nil)
        }
    }
    
}
