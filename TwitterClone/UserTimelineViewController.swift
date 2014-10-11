//
//  UserTimelineViewController.swift
//  TwitterClone
//
//  Created by Casey R White on 10/10/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class UserTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register TweetCell.xib
        let tweetCellNib = UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle())
        self.tableView.registerNib(tweetCellNib!,forCellReuseIdentifier: "TWEET_CELL")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL") as TweetCell
//        let tweet = self.tweets?[indexPath.row]
//        // configure the cell's text and image
//        if let tweetToConfigure = tweet {
//            configureTweetCell(cell, atIndexPath: indexPath, withTweet: tweetToConfigure)
//        }
        
        return cell
    }

}
