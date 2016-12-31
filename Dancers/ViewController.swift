//
//  ViewController.swift
//  Dancers
//
//  Created by 田山　由理 on 2016/12/31.
//  Copyright © 2016年 Yuri Tayama. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var sortTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var videoListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Color
        self.videoListTableView.backgroundColor = setColorPattern.Blue.makeBaseColor()
        
        let layer = CAGradientLayer()
        var gradiationColors:[Any] = []
        gradiationColors = setColorPattern.Blue.makeGradation()
        layer.colors = gradiationColors
        layer.frame = CGRect(x: 0, y: 0 , width: self.view.frame.size.width, height: self.view.frame.size.height - 64 + headerView.frame.size.height)
        videoListTableView.layer.addSublayer(layer)
        
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
}

