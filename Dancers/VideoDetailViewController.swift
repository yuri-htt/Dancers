//
//  VideoDetailViewController.swift
//  Dancers
//
//  Created by 田山　由理 on 2017/01/05.
//  Copyright © 2017年 Yuri Tayama. All rights reserved.
//

import UIKit
import RealmSwift
import WebKit

enum ExpandBtnStatus {
    case opened
    case closed
}

class VideoDetailViewController:UIViewController, UITableViewDataSource, UITableViewDelegate, WKNavigationDelegate {

    fileprivate var expandBtnState: ExpandBtnStatus = .closed
    var colorType:ColorPattern = .Blue
    var videoMap:VideoMap?
    var video:Video?
    
    @IBOutlet weak var backNavBtn: UIBarButtonItem!
    @IBOutlet weak var videoWebView: UIWebView!
    @IBOutlet weak var videoDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setColors()
        setCellHeight()
        setVideo()
        
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
        
        self.videoDetailTableView.estimatedRowHeight = 270
        self.videoDetailTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func setVideo() {
        if let url = self.video?.embedded_url {
            let urlRequest = URLRequest(url: NSURL(string:url) as! URL)
            //let urlRequest = URLRequest(url: NSURL(string:"https://www.youtube.com/watch?v=0v5wtDt2Wbc&feature=player_embedded") as! URL)
            self.videoWebView.loadRequest(urlRequest)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.videoMap?.videos!.count)! + 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UITableViewAutomaticDimension
        case 1:
            if expandBtnState == .opened {
                return UITableViewAutomaticDimension
            } else {
                return 0
            }
        default:
            return 100
        }
    }
    
    @IBAction func didPressbackNavBtn(_ sender: UIBarButtonItem) {
        self.navigationController!.popToRootViewController(animated: true)
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
            cell.expandBtn.addTarget(self, action: #selector(VideoDetailViewController.expandBtnTapped(_:)), for: .touchUpInside)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoDetailDescriptionCell", for: indexPath)  as! VideoDetailDescriptionCell
            cell.backgroundColor = UIColor.clear
            cell.descriptionLabel.text = self.video?.description
            cell.layoutIfNeeded()
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListSCell", for: indexPath)  as! VideoListSCell
            let index = indexPath.row - 2
            cell.backgroundColor = UIColor.clear
            cell.thumbnailImageView.kf.setImage(with: URL(string: (self.videoMap?.videos![index].thumbnail_url)!))
            cell.videoTitleLabel.text = self.videoMap?.videos![index].title
            cell.favoriteCountLabel.text = self.videoMap?.videos![index].favorite_counter
            cell.viewCountLabel.text = self.videoMap?.videos![index].view_counter
            cell.creatorNameLabel.text = self.videoMap?.videos![index].creator
            if let totalSec = self.videoMap?.videos![index].length_seconds {
                cell.playbackTimeLabel.text = Utils.convertSec(seconds: totalSec)
            }
            return cell
        }
    }
    
    func expandBtnTapped(_ sender: UIButton) {
        
        if self.expandBtnState == .closed {
            self.expandBtnState = .opened
            let upperAngle:CGFloat = CGFloat(180 * M_PI / 180)
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                sender.transform = CGAffineTransform(rotationAngle: upperAngle)
            }, completion: nil)
            openDescriptionArea(open: true)
        } else {
            self.expandBtnState = .closed
            let underAngle:CGFloat = CGFloat(0 * M_PI / 180)
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                sender.transform = CGAffineTransform(rotationAngle: underAngle)
            }, completion: nil)
            openDescriptionArea(open: false)
        }
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
        
        if let videoMap = self.videoMap, let videos = videoMap.videos, videos.count > indexPath.row - 2 {
            self.video = self.videoMap?.videos![indexPath.row - 2]
            setVideo()
            self.videoDetailTableView.reloadData()
        }
        
    }
    
    func openDescriptionArea(open:Bool) {
        
        let indexPath:NSIndexPath = NSIndexPath(row: 1, section: 0)
        let cell = self.videoDetailTableView.dequeueReusableCell(withIdentifier: "VideoDetailDescriptionCell", for: indexPath as IndexPath)  as! VideoDetailDescriptionCell
        
        if open {
            self.videoDetailTableView.beginUpdates()
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                cell.isHidden = false
            })
            self.videoDetailTableView.endUpdates()
        } else {
            self.videoDetailTableView.beginUpdates()
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                cell.isHidden = true
            })
            self.videoDetailTableView.endUpdates()
        }
    }
    
}
