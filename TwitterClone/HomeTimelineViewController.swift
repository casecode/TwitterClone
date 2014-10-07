//
//  HomeTimelineViewController.swift
//  TwitterClone
//
//  Created by Casey R White on 10/6/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit
import Accounts
import Social

class HomeTimelineViewController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets : [Tweet]?
    var twitterAccount: ACAccount?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load tweets using Twitter API
        
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
                    switch response.statusCode {
                    case 200...299:
                        // if request successful, parse response data into tweets
                        self.tweets = Tweet.parseJSONDataIntoTweets(data)
                        // once tweets set, reload tableView on main thread
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.tableView.reloadData()
                        })
                    case 400...499:
                        println("Client error")
                    case 500...599:
                        println("Server error")
                    default:
                        println("Unknown error")
                    }
                })
            }
        }
        
//        // Code for loading data from tweets.json file
//        if let path = NSBundle.mainBundle().pathForResource("tweets", ofType: "json") {
//            var error : NSError?
//            let jsonData = NSData(contentsOfFile: path)
//            self.tweets = Tweet.parseJSONDataIntoTweets(jsonData!)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL") as TweetCell
        let tweet = self.tweets?[indexPath.row]
        // configure the cell's text
        configureTweetCell(cell, withTweet: tweet)
        
        return cell
    }
    
    // Configure cell's image and text
    func configureTweetCell(cell: TweetCell, withTweet tweet: Tweet?) {
        cell.tweet.text = tweet?.text
        cell.userProfile.image = tweet?.userProfileImage!
    }

}
