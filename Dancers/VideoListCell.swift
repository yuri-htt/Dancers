//
//  VideoListCell.swift
//  Dancers
//
//  Created by 田山　由理 on 2016/12/31.
//  Copyright © 2016年 Yuri Tayama. All rights reserved.
//

import UIKit

class VideoListCell: UITableViewCell {

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!    
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var playbackTimeLabel: UILabel!
    
    @IBOutlet weak var creatorNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
