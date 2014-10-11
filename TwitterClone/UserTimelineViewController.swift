//
//  UserTimelineViewController.swift
//  TwitterClone
//
//  Created by Casey R White on 10/10/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class UserTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var userID: Int = 0
    var tweets: [Tweet]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("Hello: \(self.userID)")
        // Register TweetCell.xib
        let tweetCellNib = UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle())
        self.tableView.registerNib(tweetCellNib!,forCellReuseIdentifier: "TWEET_CELL")
        
        // Set display options for tableView
        setTableViewDisplayOptions()
        
        // Fetch Tweets from home timeline
        fetchUserTimeline()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTableViewDisplayOptions() {
        // Self sizing cells
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func fetchUserTimeline() {
        let targetURL = "https://api.twitter.com/1.1/statuses/user_timeline.json?user_id=\(self.userID)"
        // Fetch Home Timeline using TwitterService singleton
        let twitterService = TwitterService.sharedInstance
        twitterService.fetchTimeline(targetURL: targetURL) { (errorMessage, tweets) -> () in
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
        if let tweetToConfigure = tweet {
            TweetCell.configureCell(cell, atIndexPath: indexPath, forTableView: self.tableView, withTweet: tweetToConfigure)
        }
        
        return cell
    }
    
    // Move to SINGLE_TWEET_VC after selecting row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tweet = self.tweets?[indexPath.row]
        let destinationVC = self.storyboard?.instantiateViewControllerWithIdentifier("SINGLE_TWEET_VC") as SingleTweetViewController
        destinationVC.tweetToDisplay = tweet
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }

}
