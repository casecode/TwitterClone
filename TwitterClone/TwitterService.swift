//
//  TwitterService.swift
//  TwitterClone
//
//  Created by Casey R White on 10/8/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import Foundation
import Accounts
import Social

class TwitterService {
    
    var twitterAccount: ACAccount?
    let imageQueue = NSOperationQueue()
    
    init() {
        self.imageQueue.maxConcurrentOperationCount = 6
    }
    
    class var sharedInstance: TwitterService {
        struct Static {
            static let instance = TwitterService()
        }
        return Static.instance
    }
    
    func fetchHomeTimeline(completionHandler: (errorMessage: String?, tweets: [Tweet]?) -> ()) {
        // Grab Twitter Accounts
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        // Request Twitter Account access from user
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted, error) -> Void in
            // if user grants access
            if granted {
                // set twitterAccount to user's first Twitter Account
                let accounts = accountStore.accountsWithAccountType(accountType)
                self.twitterAccount = accounts.first as ACAccount?
                
                // Set up Twitter GET request
                let targetURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
                let url = NSURL(string: targetURL)
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
                // Attach account to request
                twitterRequest.account = self.twitterAccount
                
                // Send http request
                twitterRequest.performRequestWithHandler({ (data, response, error) -> Void in
                    // handle http response
                    var tweets: [Tweet]?
                    var errorMessage: String?
                    if error == nil {
                        switch response.statusCode {
                        case 200...299:
                            // if request successful, parse response data into tweets
                            tweets = self.parseJSONDataIntoTweets(data)
                        case 400...499:
                            errorMessage = "Bad request"
                        case 500...599:
                            errorMessage = "Server error"
                        default:
                            errorMessage = "Unknown error"
                        }
                    } else {
                        errorMessage = "ERROR: \(error.localizedDescription as String)"
                    }
                    // Resolve completionHandler
                    completionHandler(errorMessage: errorMessage, tweets: tweets)
                })
            }
        }
    }
    
    func parseJSONDataIntoTweets(rawJSONData : NSData) -> [Tweet]? {
        var error : NSError?
        if let JSONArray = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSArray {
            
            var tweets = [Tweet]()
            
            for JSONDictionary in JSONArray {
                if let tweetData = JSONDictionary as? NSDictionary {
                    var newTweet = Tweet(tweetData: tweetData)
                    tweets.append(newTweet)
                }
            }
            
            tweets.sort { $0.text < $1.text }
            return tweets
        }
        // else
        return nil
    }
    
    func downloadUserAvatarImageforTweet(tweet: Tweet, completionHandler: (error: String?, avatarImage: UIImage?) -> ()) {
        
        self.imageQueue.addOperationWithBlock { () -> Void in
            let url = NSURL(string: tweet.userAvatarUrl)
            let imageData = NSData(contentsOfURL: url!)
            var image: UIImage?, errorMessage: String?
            if imageData!.length > 0 {
                image = UIImage(data: imageData!)
                tweet.userAvatarImage = image
            } else {
                errorMessage = "No image found"
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(error: errorMessage, avatarImage: image)
            })
        }
    }
    
}