//
//  ViewController.swift
//  Nerdologia
//
//  Created by John Lima on 5/27/16.
//  Copyright © 2016 limadeveloper. All rights reserved.
//

import UIKit
import FlowingMenu
import AlamofireImage

class ViewController: UIViewController, VideoModelDelegate {
    
    // MARK: - Properties
    @IBOutlet fileprivate var tableView: UITableView!
    @IBOutlet fileprivate var collectionView: UICollectionView!
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
        
        model.delegate = self
        
        let back = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = back
        navigationController?.navigationBar.tintColor = .white
        
        collectionView.setCollectionViewLayout(GridFlowLayout(), animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if  let selectedPlayList = UserDefaults.standard.object(forKey: KeyPlayListId.Selected.rawValue) as? DictionaryType,
            let id = selectedPlayList[DictionaryKey.id.rawValue] as? String,
            let index = selectedPlayList[DictionaryKey.index.rawValue] as? Int {
            
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
    
    fileprivate func getNumberOfItems() -> Int {
        return videos.count
    }
    
    fileprivate func getHeightForItem(index: Int) -> CGFloat {
        let _ = videos[index].videoThumbnailSize
        let height: CGFloat = (view.frame.size.width / 480) * 344
        return height
    }
    
    fileprivate func setupCell(cell: AnyObject?, index: Int) {
        
        let imageView = cell?.viewWithTag(1) as? UIImageView
        let backgroundImageView = cell?.viewWithTag(3) as? UIImageView
        let label = cell?.viewWithTag(2) as? UILabel
        
        imageView?.image = nil
        backgroundImageView?.image = nil
        
        let videoTitle = videos[index].videoTitle
        label?.text = videoTitle
        
        if let videoThumbnailUrlString = videos[index].videoThumbnailUrl, let videoThumbnailUrl = URL(string: videoThumbnailUrlString) {
            imageView?.af_setImage(withURL: videoThumbnailUrl)
            backgroundImageView?.af_setImage(withURL: videoThumbnailUrl)
        }
    }
    
    fileprivate func selectItemAt(index: Int) {
        selectedVideo = videos[index]
        performSegue(withIdentifier: detailSegueName, sender: nil)
    }
    
    // MARK: - VideoModel Delegate
    func dataReady() {
        videos = model.videoArray
        activityIndicatorView.stopAnimating()
        tableView.reloadData()
        collectionView.reloadData()
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

extension ViewController: FlowingMenuDelegate {

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
    
    func flowingMenu(_ flowingMenu: FlowingMenuTransitionManager, widthOfMenuView menuView: UIView) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return view.frame.size.width / 3.5
        }else {
            return view.frame.size.width / 1.7
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfItems()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getHeightForItem(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)
        setupCell(cell: cell, index: indexPath.row)
        return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectItemAt(index: indexPath.row)
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath)
        setupCell(cell: cell, index: indexPath.item)
        return cell
    }
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectItemAt(index: indexPath.item)
    }
}

