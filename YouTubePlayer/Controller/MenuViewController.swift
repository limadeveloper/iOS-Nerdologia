//
//  MenuViewController.swift
//  Nerdologia
//
//  Created by John Lima on 5/28/16.
//  Copyright © 2016 John Lima. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private let cellName = "MenuCell"
    private let playLists = PlayList.getPlayList()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playLists.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(self.cellName) as! MenuTableViewCell
        
        let playList = self.playLists[indexPath.row]
        
        cell.displayNameLabel.text = playList.playlistName
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let playList = self.playLists[indexPath.row]
        
        let index: Int = playList.playListIndex
        let id: String = playList.playListId
        let selectedPlayList: NSDictionary = ["index": index, "id": id]
        
        NSUserDefaults.standardUserDefaults().setObject(selectedPlayList, forKey: KeyPlayListId.Selected.rawValue)
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }

}
