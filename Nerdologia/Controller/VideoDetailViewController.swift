//
//  VideoDetailViewController.swift
//  Nerdologia
//
//  Created by John Lima on 5/27/16.
//  Copyright © 2016 limadeveloper. All rights reserved.
//

import UIKit
import AlamofireImage

class VideoDetailViewController: UIViewController, UIWebViewDelegate {

    // MARK - Properties
    @IBOutlet fileprivate weak var webView: UIWebView!
    @IBOutlet fileprivate weak var videoTitle: UILabel!
    @IBOutlet fileprivate weak var videoDescription: UITextView!
    @IBOutlet fileprivate weak var heightConstraintWebView: NSLayoutConstraint!
    @IBOutlet fileprivate weak var imageViewBackgroundNavigation: UIImageView!
    
    fileprivate let videoModel = VideoModel()
    
    var selectedVideo: Video?
    
    // MARK - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        
        if let videoThumbnailUrlString = selectedVideo?.videoThumbnailUrl, let videoThumbnailUrl = URL(string: videoThumbnailUrlString) {
            imageViewBackgroundNavigation.af_setImage(withURL: videoThumbnailUrl)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        heightConstraintWebView.constant = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let video = selectedVideo {
            
            videoTitle.text = video.videoTitle
            videoDescription.text = video.videoDescription
            
            setupWebView(videoId: video.videoId)
        }
    }
    
    // MARK - Actions
    @IBAction fileprivate func done() {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupWebView(videoId: String?) {
        
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        
        let width = view.frame.size.width
        let height = (width/320) * 180
        
        self.heightConstraintWebView.constant = height
        
        guard let videoId = videoId else { return }
        let stringUrl = videoModel.getInfoVideoUrlBy(id: videoId)
        
        guard let url = URL(string: stringUrl) else { return }
        let request: URLRequest = URLRequest(url: url)
        
        webView.loadRequest(request)
    }

}
