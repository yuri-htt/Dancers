//
//  SegmentedControlCell.swift
//  Dancers
//
//  Created by 田山　由理 on 2016/12/31.
//  Copyright © 2016年 Yuri Tayama. All rights reserved.
//

import UIKit

class SegmentedControlCell: UITableViewCell {

    @IBOutlet weak var sortTypeSegmentedControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
