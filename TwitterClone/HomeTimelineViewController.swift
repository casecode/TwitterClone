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
    var twitterService: TwitterService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set display options for tableView
        setTableViewDisplayOptions()
        
        // Set TwitterService Singleton
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.twitterService = appDelegate.twitterService
        // Fetch Tweets from user timeline
        fetchHomeTimeline()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setTableViewDisplayOptions() {
        // Self sizing cells
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        // Make circular UIImageView for display user profile image
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL") as TweetCell
//        cell.imageView?.layer.cornerRadius = cell.imageView!.frame.size.width / 2
//        cell.imageView?.clipsToBounds = true
    }
    
    func fetchHomeTimeline() {
        self.twitterService.fetchHomeTimeline { (errorMessage, tweets) -> () in
            if let error = errorMessage {
                println(error)
            } else {
                println("\(tweets!.count) tweets fetched successfully")
                // Populate tweets and refresh tableView on main thread
                self.tweets = tweets!
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
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
        // configure the cell's text and image
        configureTweetCell(cell, withTweet: tweet)
        
        return cell
    }
    
    // Configure cell's image and text
    func configureTweetCell(cell: TweetCell, withTweet tweet: Tweet?) {
        cell.tweet.text = tweet?.text
        cell.userProfile.image = tweet?.userProfileImage!
    }

}
