//
//  ViewController.swift
//  Dancers
//
//  Created by 田山　由理 on 2016/12/31.
//  Copyright © 2016年 Yuri Tayama. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import Kingfisher

enum SidebarStatus {
    case opened
    case closed
}

enum SearchAreaStatus {
    case opened
    case closed
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var searchAreaView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var segmentedControlAreaView: UIView!
    @IBOutlet weak var sortTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var videoListTableView: UITableView!
    @IBOutlet weak var sideMenuContainer: UIView!
    @IBOutlet weak var handleSideButton: UIButton!
    
    @IBOutlet weak var searchAreaHeightConstraint: NSLayoutConstraint!
    
    fileprivate var sideState: SidebarStatus = .closed
    fileprivate var searchAreaState: SidebarStatus = .closed
    var colorType:ColorPattern = .Blue
    var videoMap:VideoMap?
    var searchKeyword:String = ""
    var sortType:VideoSortBy = .favoriteCount
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkUserExisting()
        setSearchArea()
        setCellHeight()
        setColors()
        loadVideos()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //コンテナビューと半透明ボタンはAutoLayoutをかけないでコードで再配置する
        handleSideButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        handleSideButton.isEnabled = false
        handleSideButton.backgroundColor = UIColor.darkGray
        handleSideButton.alpha = 0
        sideMenuContainer.frame = CGRect(x: -300, y: 0, width: 300, height: self.view.frame.height)
        sideMenuContainer.backgroundColor = sideMenuColor
        
        //ナビゲーションバーの上に配置するためにこの階層に対してaddSubViewを行う
        navigationController?.view.addSubview(handleSideButton)
        navigationController?.view.addSubview(sideMenuContainer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /* TableView */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoMap?.videos!.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoListCell", for: indexPath)  as! VideoListCell
        cell.backgroundColor = UIColor.clear

        cell.thumbnailImageView.kf.setImage(with: URL(string: (self.videoMap?.videos![indexPath.row].thumbnail_url)!))
        cell.videoTitleLabel.text = self.videoMap?.videos![indexPath.row].title
        cell.favoriteCountLabel.text = self.videoMap?.videos![indexPath.row].favorite_counter
        cell.viewCountLabel.text = self.videoMap?.videos![indexPath.row].view_counter
        cell.creatorNameLabel.text = self.videoMap?.videos![indexPath.row].creator
        if let totalSec = self.videoMap?.videos![indexPath.row].length_seconds {
           cell.playbackTimeLabel.text = Utils.convertSec(seconds: totalSec)
        }
        return cell
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {

        if let videoMap = self.videoMap, let videos = videoMap.videos, videos.count > indexPath.row {
            performSegue(withIdentifier: "ShowVideoDetail", sender: indexPath)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ShowVideoDetail" {
            let videoDetailViewController = segue.destination as! VideoDetailViewController
            let indexPath = sender as! IndexPath
            videoDetailViewController.videoMap = self.videoMap
            videoDetailViewController.video = self.videoMap?.videos![indexPath.row]
        }
    }
    
    /* Functions */
    func checkUserExisting() {
        
        let realm = try! Realm()
        let user = realm.objects(RUser.self)
        if user.count == 0 {
            registerUser()
        }
        
    }
    
    func registerUser() {
        
        let url = "\(BaseAPI)\(SignUp)"
        let para: Parameters = ["device_code":"1"]

        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default)
            .validate()
            .responseData { response in Utils.checkResponse(response) }
            .responseObject { (response: DataResponse<User>) in
                
                switch response.result {
                case .success:
                    if let user = response.result.value {
                        let realm = try! Realm()
                        let rUser = RUser()
                        try! realm.write {
                            rUser.id = Int(user.id!)!
                            realm.add(rUser)
                        }
                    }

                case .failure( _):
                    let alertController = UIAlertController(title: "Communication error", message: "Please try again in a good place of radio.", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    }
                    alertController.addAction(okAction)
                    
                    DispatchQueue.main.async(execute: {
                        self.present(alertController, animated: true, completion: nil)
                    })
                }
        }
    }
    
    func setSearchArea() {
        
        searchAreaView.isHidden = true
        searchTextField.isHidden = true
        searchAreaHeightConstraint.constant = 0
        searchTextField.delegate = self
        
    }
    
    func setCellHeight() {
        
        self.videoListTableView.estimatedRowHeight = 285
        self.videoListTableView.rowHeight = UITableViewAutomaticDimension
    
    }
    
    func setColors() {
        
        let realm = try! Realm()
        let rUser = realm.objects(RUser.self)
        for user in rUser {
            self.colorType = ColorPattern.getColorType(colorType: user.colorType)
        }
        
        searchAreaView.backgroundColor = headerViewColor
        segmentedControlAreaView.backgroundColor = headerViewColor
            
        // base color
        self.view.backgroundColor = self.colorType.makeBaseColor()
        self.videoListTableView.backgroundColor = UIColor.clear
        
        // gradiation
        let layer = CAGradientLayer()
        var gradiationColors:[Any] = []
        gradiationColors = self.colorType.makeGradation()
        layer.colors = gradiationColors
        layer.frame = CGRect(x: 0, y: 76 , width: self.view.frame.size.height, height: self.view.frame.size.height)
        self.view.layer.insertSublayer(layer, at: 0)

    }
    
    func setColor(colorType:String) {
        
        let layer = CAGradientLayer()
        var gradiationColors:[Any] = []
        if colorType == ColorPattern.Blue.rawValue {
            self.view.backgroundColor = ColorPattern.Blue.makeBaseColor()
            gradiationColors = ColorPattern.Blue.makeGradation()
        } else if colorType == ColorPattern.Orange.rawValue {
            self.view.backgroundColor = ColorPattern.Orange.makeBaseColor()
            gradiationColors = ColorPattern.Orange.makeGradation()
        } else if colorType == ColorPattern.Black.rawValue {
            self.view.backgroundColor = ColorPattern.Black.makeBaseColor()
            gradiationColors = ColorPattern.Black.makeGradation()
        }
        layer.colors = gradiationColors
        layer.frame = CGRect(x: 0, y: 0 , width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.layer.sublayers?.remove(at: 0)
        self.view.layer.insertSublayer(layer, at: 0)
        
    }
    
    @IBAction func didPressNavBtn(_ sender: Any) {
        sideState = SidebarStatus.opened
        changeSideMenuStatus(sideState)
    }
    
    @IBAction func closeSideMenuAciton(_ sender: Any) {
        sideState = SidebarStatus.closed
        changeSideMenuStatus(sideState)
    }

    fileprivate func changeSideMenuStatus(_ targetStatus: SidebarStatus) {
        
        if targetStatus == SidebarStatus.opened {
            
            //サイドメニューを表示状態にする
            UIView.animate(withDuration: 0.24, delay: 0, options: .curveEaseOut, animations: {
                
                self.handleSideButton.isEnabled = true
                self.handleSideButton.alpha = 0.6
                self.sideMenuContainer.frame = CGRect(x: 0, y: 0, width: 250, height: self.view.frame.height)
                
            }, completion: nil)
            
        } else {
            
            //サイドメニューを非表示状態にする
            UIView.animate(withDuration: 0.24, delay: 0, options: .curveEaseOut, animations: {
                
                self.handleSideButton.isEnabled = false
                self.handleSideButton.alpha = 0
                self.sideMenuContainer.frame = CGRect(x: -300, y: 0, width: 300, height: self.view.frame.height)
                
            }, completion: nil)
        }
    }
    
    @IBAction func didPressSearchBtn(_ sender: UIBarButtonItem) {

        if self.searchAreaState == .closed {
            
            self.searchAreaState = .opened
            self.searchAreaView.isHidden = false
            self.searchTextField.isHidden = false
            
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.searchAreaHeightConstraint.constant = 44
            }, completion: nil)
            
        } else {
            
            self.searchAreaState = .closed
            self.searchAreaView.isHidden = true
            self.searchTextField.isHidden = true
            self.searchKeyword = ""
            
            UIView.animate(withDuration: 0.24, delay: 0, options: .curveEaseOut, animations: {
                self.searchAreaHeightConstraint.constant = 0
            }, completion: nil)
                
        }
        
    }
    
    @IBAction func sortTypeChanged(_ sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            self.sortType = VideoSortBy.favoriteCount
        case 1:
            self.sortType = VideoSortBy.viewCount
        default:
            self.sortType = VideoSortBy.favoriteCount
        }
        loadVideos()
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        self.searchKeyword = self.searchTextField.text!
        searchTextField.resignFirstResponder()
        loadVideos()
        
        return true
    }
    
    func loadVideos() {
        
        let url = "\(BaseAPI)\(VideoList)"
        let para: Parameters = [
            "device_code":"1",
            "sort_code":"\(self.sortType.rawValue)",
            "title":"\(self.searchKeyword)"
        ]
        
        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default)
            .validate()
            .responseData { response in Utils.checkResponse(response) }
            .responseObject { (response: DataResponse<VideoMap>) in
                
                switch response.result {
                case .success:
                    if let videoMap = response.result.value {
                        self.videoMap = videoMap
                    }
                    self.videoListTableView.reloadData()
                    
                case .failure( _):
                    let alertController = UIAlertController(title: "Communication error", message: "Please try again in a good place of radio.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    }
                    alertController.addAction(okAction)
                    DispatchQueue.main.async(execute: {
                        self.present(alertController, animated: true, completion: nil)
                    })
                }
        }
        
    }
}

extension ViewController: SettingsTableViewControllerDelegate {
    
    func settingsTableViewController(colortType:String) {
        sideState = SidebarStatus.closed
        changeSideMenuStatus(sideState)
        setColor(colorType: colortType)
    }
    
}
