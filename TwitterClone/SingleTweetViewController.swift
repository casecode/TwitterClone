//
//  SingleTweetViewController.swift
//  TwitterClone
//
//  Created by Casey R White on 10/8/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class SingleTweetViewController: UIViewController {
    
    var tweetToDisplay: Tweet?

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var twitterHandleLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    
    @IBAction func avatarPressed(sender: AnyObject) {
        let destinationVC = self.storyboard?.instantiateViewControllerWithIdentifier("USER_TIMELINE_VC") as UserTimelineViewController
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameLabel.text = self.tweetToDisplay?.username
        self.twitterHandleLabel.text = self.tweetToDisplay?.userTwitterHandle
        self.avatarImageView.layer.cornerRadius = 8.0
        self.avatarImageView.clipsToBounds = true
        self.avatarImageView.image = self.tweetToDisplay?.userAvatarImage
        self.tweetLabel.text = self.tweetToDisplay?.text
        self.favoritesLabel.text = "\(self.tweetToDisplay!.favoriteCount)"
        self.retweetsLabel.text = "\(self.tweetToDisplay!.retweetCount)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
