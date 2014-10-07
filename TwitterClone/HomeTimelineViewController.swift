//
//  HomeTimelineViewController.swift
//  TwitterClone
//
//  Created by Casey R White on 10/6/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UITableViewDataSource {
    
    var tweets : [Tweet]?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let path = NSBundle.mainBundle().pathForResource("tweets", ofType: "json") {
            var error : NSError?
            let jsonData = NSData(contentsOfFile: path)
            self.tweets = Tweet.parseJSONDataIntoTweets(jsonData!)
        }
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
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL") as UITableViewCell
        let tweet = self.tweets?[indexPath.row]
        cell.textLabel?.text = tweet?.text
        
        return cell
    }

}
