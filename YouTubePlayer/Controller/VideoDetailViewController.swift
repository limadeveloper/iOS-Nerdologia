//
//  VideoDetailViewController.swift
//  YouTubePlayer
//
//  Created by John Lima on 5/27/16.
//  Copyright © 2016 John Lima. All rights reserved.
//

import UIKit

class VideoDetailViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var webView: UIWebView!
    @IBOutlet var videoTitle: UILabel!
    @IBOutlet var videoDescription: UITextView!
    @IBOutlet weak var heightConstraintWebView: NSLayoutConstraint!
    
    var selectedVideo: Video?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.heightConstraintWebView.constant = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        if let video = self.selectedVideo {
            
            self.videoTitle.text = video.videoTitle
            self.videoDescription.text = video.videoDescription
            
            self.setupWebView(video.videoId)
        }
    }
    
    func setupWebView(videoId: String) {
        
        self.webView.isOpaque = false
        self.webView.backgroundColor = UIColor.clear
        self.webView.scrollView.isScrollEnabled = false
        
        let width = self.view.frame.size.width
        let height = (width/320) * 180
        
        self.heightConstraintWebView.constant = height
        
        let stringUrl = "http://www.youtube.com/embed/\(videoId)?showinfo=0&modestbranding=1&frameborder=0&rel=0"
        
        let url = URL(string: stringUrl)!
        let request: URLRequest = URLRequest(url: url)
        
        self.webView.loadRequest(request)
    }

}
