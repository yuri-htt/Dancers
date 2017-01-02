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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var sortTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var videoListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkUserInfo()
        setColor()
        
        
        self.videoListTableView.estimatedRowHeight = 285
        self.videoListTableView.rowHeight = UITableViewAutomaticDimension

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoListCell", for: indexPath as IndexPath)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {

    }
    
    func checkUserInfo() {
        
        // Realmにユーザー情報が登録されているか(=既存ユーザー)確認
        let realm = try! Realm()
        let UserInfo = realm.objects(RUser).first
        if let userInfo = UserInfo {
            if userInfo.id != 0 {
               registerUser()
            }
        } else {
            registerUser()
        }
        
    }
    
    func registerUser() {
        
        //let url = "\(BaseAPI)\(SignUp)"
        let url = "http://tk2-212-15657.vs.sakura.ne.jp:8000/api/users/"
        var parameters:Parameters = Parameters()
        
        parameters["device_code"] = "1"
        //var para:[String: String] = ["device_code":"1"]
        let para: Parameters = [
            "device_code":"1"
        ]

        Alamofire.request(url, method: .post, parameters: para, encoding: JSONEncoding.default)
            .validate()
            .responseData { response in Utils.checkResponse(response) }
            .responseObject { (response: DataResponse<User>) in
                switch response.result {
                case .success:
                    //  save to Realm
                    if let user = response.result.value {
                        let realm = try! Realm()
                        var rUser = RUser()
                        try! realm.write {
                            rUser.id = user.id!
                            realm.add(rUser)
                        }
                    }

                case .failure(let _):
                    // alert
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
    
    func setColor() {
        
        // base color
        self.videoListTableView.backgroundColor = setColorPattern.Blue.makeBaseColor()
        
        // gradiation
        let layer = CAGradientLayer()
        var gradiationColors:[Any] = []
        gradiationColors = setColorPattern.Blue.makeGradation()
        layer.colors = gradiationColors
        layer.frame = CGRect(x: 0, y: 0 , width: self.view.frame.size.width, height: self.view.frame.size.height - 64 + headerView.frame.size.height)
        self.videoListTableView.layer.insertSublayer(layer, at: 0)

    }
}

