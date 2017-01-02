//
//  LeftSideMenuViewController.swift
//  Dancers
//
//  Created by 田山　由理 on 2017/01/03.
//  Copyright © 2017年 Yuri Tayama. All rights reserved.
//

import UIKit

class LeftSideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.backgroundColor = sideMenuColor

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RankingCell", for: indexPath as IndexPath)
            cell.backgroundColor = UIColor.clear
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath as IndexPath)
            cell.backgroundColor = UIColor.clear
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath as IndexPath)
            cell.backgroundColor = UIColor.clear
            return cell
        }
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
        switch indexPath.row {
        case 0:
            print("ranking")
        case 1:
            print("playlist")
        default:
            performSegue(withIdentifier: "ShowSettings", sender: indexPath)
            
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowSettings" {
            let navigationController = segue.destination as! UINavigationController
            let settingsViewController = navigationController.viewControllers.first as! SettingsTableViewController
            settingsViewController.delegate = self.parent as! ViewController
        }
    }
}
