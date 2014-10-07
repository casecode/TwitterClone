//
//  TweetCell.swift
//  TwitterClone
//
//  Created by Casey R White on 10/7/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var tweet: UITextView!
    
    @IBOutlet weak var userProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
