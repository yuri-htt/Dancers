//
//  VideoDetailCell.swift
//  Dancers
//
//  Created by 田山　由理 on 2017/01/05.
//  Copyright © 2017年 Yuri Tayama. All rights reserved.
//

import UIKit

class VideoDetailCell: UITableViewCell {

    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var playbackTimeLabel: UILabel!
    @IBOutlet weak var creatorNameLabel: UILabel!
    
    @IBOutlet weak var downloadbtn: UIButton!
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var expandBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
