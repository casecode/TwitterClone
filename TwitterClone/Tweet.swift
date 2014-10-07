//
//  Tweet.swift
//  TwitterClone
//
//  Created by Casey R White on 10/6/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import Foundation
import UIKit

class Tweet {
    
    var text: String
    var userProfileImage: UIImage?
    
    init(tweetDictionary : NSDictionary) {
        self.text = tweetDictionary["text"] as String
        
        let user = tweetDictionary["user"] as NSDictionary
        let imageUrl = user["profile_image_url"] as String
        let url = NSURL(string: imageUrl)
        if let imageData = NSData(contentsOfURL: url!) {
            self.userProfileImage = UIImage(data: imageData)
        }
    }
    
    class func parseJSONDataIntoTweets(rawJSONData : NSData) -> [Tweet]? {
        var error : NSError?
        if let JSONArray = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSArray {
            
            var tweets = [Tweet]()
            
            for JSONDictionary in JSONArray {
                if let tweetDictionary = JSONDictionary as? NSDictionary {
                    var newTweet = Tweet(tweetDictionary: tweetDictionary)
                    tweets.append(newTweet)
                }
            }
            
            tweets.sort { $0.text < $1.text }
            return tweets
        }
        // else
        return nil
    }
    
}