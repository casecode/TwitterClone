//
//  UserTimelineViewController.swift
//  TwitterClone
//
//  Created by Casey R White on 10/10/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class UserTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Use tweetPassedFromSingleTweetVC to configure Header View and identify user
    var tweetPassedFromSingleTweetVC: Tweet?
    var userID: Int = 0
    var tweets: [Tweet]?
    let userTimelineURL = "https://api.twitter.com/1.1/statuses/user_timeline.json"
    let twitterService = TwitterService.sharedInstance
    var refreshControl:UIRefreshControl!
    

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var twitterHandleLabel: UILabel!
    @IBOutlet weak var userAvatarView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure header view and set userID
        // IF tweet passed from SingleTweetVC and already had image, okay to force unwrap
        self.userID = tweetPassedFromSingleTweetVC!.userID
        self.usernameLabel.text = tweetPassedFromSingleTweetVC!.username
        self.twitterHandleLabel.text = tweetPassedFromSingleTweetVC!.userTwitterHandle
        self.userAvatarView.image = tweetPassedFromSingleTweetVC!.userAvatarImage!
        
        // Apply rounded corners and border to image
        self.userAvatarView.layer.cornerRadius = 8.0
        self.userAvatarView.clipsToBounds = true
        self.userAvatarView.layer.borderWidth = 3.0
        self.userAvatarView.layer.borderColor = UIColor.whiteColor().CGColor
        
        // Register TweetCell.xib
        let tweetCellNib = UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle())
        self.tableView.registerNib(tweetCellNib!,forCellReuseIdentifier: "TWEET_CELL")
        
        // Set display options for tableView
        setTableViewDisplayOptions()
        
        // Fetch Tweets from home timeline
        fetchUserTimeline()
        
        // Pull to refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refreshTimeline:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func setTableViewDisplayOptions() {
        // Self sizing cells
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func fetchUserTimeline() {
        let targetURL = self.userTimelineURL + "?user_id=" + self.userID.description
        // Fetch Home Timeline using TwitterService singleton
        self.twitterService.fetchTimeline(targetURL: targetURL) { (errorMessage, tweets) -> () in
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
    
    func refreshTimeline(sender: AnyObject!) {
        println("Starting Pull To Refresh")
        let mostRecentTweet = self.tweets![0]
        let targetURL = self.userTimelineURL + "?user_id=" + self.userID.description + "&since_id=" + mostRecentTweet.id.description
        
        self.twitterService.fetchTimeline(targetURL: targetURL) { (errorMessage, tweets) -> () in
            if let error = errorMessage {
                println(error)
            } else {
                println("\(tweets!.count) new tweets fetched successfully")
                // Populate tweets and refresh tableView on main thread
                self.tweets = tweets! + self.tweets!
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
        // Ending refresh outside completion block ensures refresh ends regardless of whether request is successful AND that endRefresh called on main thread
        self.refreshControl.endRefreshing()
    }

}
