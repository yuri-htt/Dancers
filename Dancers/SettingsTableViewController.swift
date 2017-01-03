//
//  SettingsTableViewController.swift
//  Dancers
//
//  Created by 田山　由理 on 2017/01/03.
//  Copyright © 2017年 Yuri Tayama. All rights reserved.
//

import UIKit
import RealmSwift

protocol SettingsTableViewControllerDelegate {
    func settingsTableViewController(colortType:String)
}

class SettingsTableViewController: UITableViewController {

    var selectedColorType:String?
    var delegate:SettingsTableViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        let rUser = realm.objects(RUser.self)
        for user in rUser {
            self.selectedColorType = user.colorType
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for i in 0...2 {
            let indexPath: NSIndexPath = NSIndexPath(row: i, section: 0)
            if let cell: UITableViewCell = tableView.cellForRow(at: indexPath as IndexPath) {
                cell.accessoryType = .none
            }
        }
        
        // 対象のセルにチェックマークを付けます
        if let cell: UITableViewCell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            self.selectedColorType = cell.textLabel?.text
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if cell.textLabel?.text == self.selectedColorType {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    @IBAction func didPressNavBtn(_ sender: Any) {
        let realm = try! Realm()
        let rUser = realm.objects(RUser)
        if let user = rUser.first {
            try! realm.write() {
                user.colorType = self.selectedColorType!
            }
        }
        self.dismiss(animated: true, completion: nil)
        self.delegate.settingsTableViewController(colortType: self.selectedColorType!)
    }
}
