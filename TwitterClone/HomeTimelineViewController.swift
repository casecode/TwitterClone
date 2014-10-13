//
//  HomeTimelineViewController.swift
//  TwitterClone
//
//  Created by Casey R White on 10/6/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets : [Tweet]?
    let homeTimelineURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    let twitterService = TwitterService.sharedInstance
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register TweetCell.xib
        let tweetCellNib = UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle())
        self.tableView.registerNib(tweetCellNib!,forCellReuseIdentifier: "TWEET_CELL")
        
        // Set display options for tableView
        setTableViewDisplayOptions()

        // Fetch Tweets from home timeline
        fetchHomeTimeline()
        
        // Pull to refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refreshTimeline:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
    }
    
    // Refresh cell after view appears to resize auto-sized cells
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
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
    
    // Infinite Scrolling
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let oldestTweetIndex = self.tweets!.count - 1
        if indexPath.row == oldestTweetIndex {
            let oldestTweet = self.tweets![oldestTweetIndex]
            let targetURL = self.homeTimelineURL + "?max_id=" + oldestTweet.id.description
            
            self.twitterService.fetchTimeline(targetURL: targetURL) { (errorMessage, tweets) -> () in
                if let error = errorMessage {
                    println(error)
                } else {
                    println("\(tweets!.count) new tweets fetched successfully")
                    // Populate tweets and refresh tableView on main thread
                    self.tweets = self.tweets! + tweets!
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func setTableViewDisplayOptions() {
        // Self sizing cells
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func fetchHomeTimeline() {
        // Fetch Home Timeline using TwitterService singleton
        self.twitterService.fetchTimeline(targetURL: self.homeTimelineURL) { (errorMessage, tweets) -> () in
            if let error = errorMessage {
                println(error)
            } else {
                println("\(tweets!.count) tweets fetched successfully")
                // Populate tweets and refresh tableView on main thread
                self.tweets = tweets!
                self.tableView.reloadData()
            }
        }
    }
    
    func refreshTimeline(sender: AnyObject!) {
        println("Starting Pull To Refresh")
        let mostRecentTweet = self.tweets![0]
        let targetURL = self.homeTimelineURL + "?since_id=" + mostRecentTweet.id.description
        
        self.twitterService.fetchTimeline(targetURL: targetURL) { (errorMessage, tweets) -> () in
            if let error = errorMessage {
                println(error)
            } else {
                println("\(tweets!.count) new tweets fetched successfully")
                // Populate tweets and refresh tableView on main thread
                self.tweets = tweets! + self.tweets!
                self.tableView.reloadData()
            }
        }
        // End refresh whether request successful or not
        self.refreshControl.endRefreshing()
    }

}
