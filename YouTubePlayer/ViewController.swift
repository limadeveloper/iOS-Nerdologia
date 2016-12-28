//
//  ViewController.swift
//  YouTubePlayer
//
//  Created by John Lima on 5/27/16.
//  Copyright © 2016 limadeveloper. All rights reserved.
//

import UIKit
import FlowingMenu
import AlamofireImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, VideoModelDelegate, FlowingMenuDelegate {
    
    // MARK: - Properties
    @IBOutlet fileprivate var tableView: UITableView!
    @IBOutlet fileprivate var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet fileprivate var flowingMenuTransitionManager: FlowingMenuTransitionManager!
    
    fileprivate var videos = [Video]()
    fileprivate let model = VideoModel()
    fileprivate var selectedVideo: Video?
    fileprivate let presentSegueName = "PresentMenuSegue"
    fileprivate let dismissSegueName = "DismissMenuSegue"
    fileprivate let detailSegueName = "DetailSegue"
    fileprivate let cellName = "cell"
    fileprivate var menu: UIViewController?
    fileprivate var playListId = String()

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flowingMenuTransitionManager.setInteractivePresentationView(view)
        flowingMenuTransitionManager.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        model.delegate = self
        
        let back = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = back
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let selectedPlayList = UserDefaults.standard.object(forKey: KeyPlayListId.Selected.rawValue) as? DictionaryType, let id = selectedPlayList[DictionaryKey.id.rawValue] as? String, let index = selectedPlayList[DictionaryKey.index.rawValue] as? Int {
            playListId = id
            model.getFeedVideos(playListId: playListId)
            navigationItem.title = PlayList.getPlayList()[index-1].playlistName
        }else if let id = PlayList.getPlayList().first?.playListId, let name = PlayList.getPlayList().first?.playlistName {
            model.getFeedVideos(playListId: id)
            navigationItem.title = name
        }
    }
    
    // MARK: - Actions
    @IBAction fileprivate func unwindToMainViewController(sender: UIStoryboardSegue) {
        
    }
    
    // MARK: - VideoModel Delegate
    func dataReady() {
        videos = model.videoArray
        activityIndicatorView.stopAnimating()
        tableView.reloadData()
    }
    
    // MARK: - FlowingMenu Delegate
    func colorOfElasticShapeInFlowingMenu(_ flowingMenu: FlowingMenuTransitionManager) -> UIColor? {
        return UIColor(hexString: .first)
    }
    
    func flowingMenuNeedsPresentMenu(_ flowingMenu: FlowingMenuTransitionManager) {
        performSegue(withIdentifier: presentSegueName, sender: self)
    }
    
    func flowingMenuNeedsDismissMenu(_ flowingMenu: FlowingMenuTransitionManager) {
        menu?.performSegue(withIdentifier: dismissSegueName, sender: self)
    }

    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let _ = videos[indexPath.row].videoThumbnailSize
        let height: CGFloat = (view.frame.size.width / 480) * 344
        return height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)
        
        let imageView = cell.viewWithTag(1) as? UIImageView
        let backgroundImageView = cell.viewWithTag(3) as? UIImageView
        let label = cell.viewWithTag(2) as? UILabel
        
        imageView?.image = nil
        backgroundImageView?.image = nil
        
        let videoTitle = videos[indexPath.row].videoTitle
        label?.text = videoTitle
        
        if let videoThumbnailUrlString = videos[indexPath.row].videoThumbnailUrl, let videoThumbnailUrl = URL(string: videoThumbnailUrlString) {
            imageView?.af_setImage(withURL: videoThumbnailUrl)
            backgroundImageView?.af_setImage(withURL: videoThumbnailUrl)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedVideo = videos[indexPath.row]
        performSegue(withIdentifier: detailSegueName, sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case detailSegueName:
                let controller = segue.destination as? VideoDetailViewController
                controller?.selectedVideo = selectedVideo
            case presentSegueName:
                let controller = segue.destination
                controller.transitioningDelegate = flowingMenuTransitionManager
                flowingMenuTransitionManager.setInteractiveDismissView(controller.view)
                menu = controller
            default:
                break
            }
        }
    }
}

