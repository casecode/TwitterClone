//
//  TweetCell.swift
//  TwitterClone
//
//  Created by Casey R White on 10/7/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var twitterHandleLabel: UILabel!
    @IBOutlet weak var userAvatarView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.userAvatarView.layer.cornerRadius = 8.0
        self.userAvatarView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Configure cell's image and text
    class func configureCell(cell: TweetCell, atIndexPath indexPath: NSIndexPath, forTableView tableView: UITableView, withTweet tweet: Tweet) {
        cell.tweetLabel.text = tweet.text
        cell.usernameLabel.text = tweet.username
        cell.twitterHandleLabel.text = tweet.userTwitterHandle
        // Grab user image for cell
        let twitterService = TwitterService.sharedInstance
        twitterService.downloadUserAvatarImageforTweet(tweet, completionHandler: { (error, avatarImage) -> () in
            if error == nil {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    let cellForImage = tableView.cellForRowAtIndexPath(indexPath) as TweetCell?
                    cellForImage?.userAvatarView.image = avatarImage
                })
            }
        })
    }

}
