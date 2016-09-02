//
//  ViewController.swift
//  YouTubePlayer
//
//  Created by John Lima on 5/27/16.
//  Copyright © 2016 John Lima. All rights reserved.
//

import UIKit
import FlowingMenu

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, VideoModelDelegate, FlowingMenuDelegate {
    
    // MARK: - Properties
    @IBOutlet var table: UITableView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var flowingMenuTransitionManager: FlowingMenuTransitionManager!
    
    var videos: [Video] = [Video]()
    let model: VideoModel = VideoModel()
    var selectedVideo: Video?
    
    let presentSegueName = "PresentMenuSegue"
    let dismissSegueName = "DismissMenuSegue"
    let detailSegueName = "DetailSegue"
    let cellName = "cell"
    
    var menu: UIViewController?
    
    var playListId: String = String()

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.flowingMenuTransitionManager.setInteractivePresentationView(view)
        self.flowingMenuTransitionManager.delegate = self
        
        self.table.delegate = self
        self.table.dataSource = self
        
        self.model.delegate = self
        
        let back = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print("view did appear")
        
        if let selectedPlayList = NSUserDefaults.standardUserDefaults().objectForKey(KeyPlayListId.Selected.rawValue) as? NSDictionary {
            print("*** playList: \(selectedPlayList["id"])")
            self.playListId = selectedPlayList["id"] as! String
            self.model.getFeedVideos(playListId: self.playListId)
            self.title = PlayList.getPlayList()[(selectedPlayList["index"] as! Int)-1].playlistName
        }else {
            print("playList default")
            self.model.getFeedVideos(playListId: PlayList.getPlayList()[0].playListId)
            self.title = PlayList.getPlayList()[0].playlistName
        }
    }
    
    // MARK: - Actions
    @IBAction func unwindToMainViewController(sender: UIStoryboardSegue) {
        
    }
    
    // MARK: - VideoModel Delegate
    func dataReady() {
        self.videos = self.model.videoArray
        self.activityIndicatorView.stopAnimating()
        self.table.reloadData()
    }
    
    // MARK: - FlowingMenu Delegate
    func colorOfElasticShapeInFlowingMenu(flowingMenu: FlowingMenuTransitionManager) -> UIColor? {
        return UIColor(red: 31.0/255.0, green: 33.0/255.0, blue: 36.0/255.0, alpha: 1)
    }
    
    func flowingMenuNeedsPresentMenu(flowingMenu: FlowingMenuTransitionManager) {
        self.performSegueWithIdentifier(self.presentSegueName, sender: self)
    }
    
    func flowingMenuNeedsDismissMenu(flowingMenu: FlowingMenuTransitionManager) {
        print("dismiss menu")
        self.menu?.performSegueWithIdentifier(self.dismissSegueName, sender: self)
    }

    // MARK: - TableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videos.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let _ = self.videos[indexPath.row].videoThumbnailSize
        let height: CGFloat = (self.view.frame.size.width / 480) * 344
        return height
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCellWithIdentifier(self.cellName, forIndexPath: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        let backgroundImageView = cell.viewWithTag(3) as! UIImageView
        
        imageView.image = nil
        backgroundImageView.image = nil
        
        let videoTitle = videos[indexPath.row].videoTitle
        let label = cell.viewWithTag(2) as! UILabel
        label.text = videoTitle
        
        let videoThumbnailUrlString = videos[indexPath.row].videoThumbnailUrl
        let videoThumbnailUrl = NSURL(string: videoThumbnailUrlString)
        
        if videoThumbnailUrl != nil {
            let request = NSURLRequest(URL: videoThumbnailUrl!)
            let session = NSURLSession.sharedSession()
            let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
                if let data = data {
                    dispatch_async(dispatch_get_main_queue(), {
                        imageView.image = UIImage(data: data)
                        backgroundImageView.image = UIImage(data: data)
                    })
                }
            })
            dataTask.resume()
        }
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedVideo = self.videos[indexPath.row]
        self.performSegueWithIdentifier(self.detailSegueName, sender: self)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == self.detailSegueName {
            
            let controller = segue.destinationViewController as! VideoDetailViewController
            
            controller.selectedVideo = self.selectedVideo
            
        }else if segue.identifier == self.presentSegueName {
            
            let controller = segue.destinationViewController
            
            controller.transitioningDelegate = self.flowingMenuTransitionManager
            
            self.flowingMenuTransitionManager.setInteractiveDismissView(controller.view)
            self.menu = controller
            
            print("present menu")
            
            /*self.playListId = ""
            NSUserDefaults.standardUserDefaults().removeObjectForKey(KeyPlayListId.Selected.rawValue)
            NSUserDefaults.standardUserDefaults().synchronize()
            
            self.videos = []
            self.activityIndicatorView.startAnimating()
            self.table.reloadData()*/
        }
    }
}

