//
//  Tweet.swift
//  TwitterClone
//
//  Created by Casey R White on 10/6/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class Tweet {
    
    var text: String
    var retweetCount: Int
    var favoriteCount: Int
    var userID: Int
    var username: String
    var userTwitterHandle: String
    var userAvatarUrl: String
    var userAvatarImage: UIImage?
    
    init(tweetData : NSDictionary) {
        self.text = tweetData["text"] as String
        self.retweetCount = tweetData["retweet_count"] as Int
        self.favoriteCount = tweetData["favorite_count"] as Int
        
        // Set user info
        let user = tweetData["user"] as NSDictionary
        self.userID = user["id"] as Int
        self.username = user["name"] as String
        let screenName = user["screen_name"] as String
        self.userTwitterHandle = "@\(screenName)"
        self.userAvatarUrl = user["profile_image_url"] as String
    }
    
}