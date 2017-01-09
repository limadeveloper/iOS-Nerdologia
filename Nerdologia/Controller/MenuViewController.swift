//
//  MenuViewController.swift
//  Nerdologia
//
//  Created by John Lima on 5/28/16.
//  Copyright © 2016 limadeveloper. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet fileprivate weak var tableView: UITableView!
    
    fileprivate let cellName = "MenuCell"
    fileprivate let playLists = PlayList.getPlayList()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName) as! MenuTableViewCell
        
        let playList = playLists[indexPath.row]
        
        cell.displayNameLabel.text = playList.playlistName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let playList = playLists[indexPath.row]
        
        let index: Int = playList.playListIndex
        let id: String = playList.playListId
        let selectedPlayList: DictionaryType = [DictionaryKey.index.rawValue: index, DictionaryKey.id.rawValue: id]
        
        UserDefaults.standard.set(selectedPlayList, forKey: KeyPlayListId.Selected.rawValue)
        UserDefaults.standard.synchronize()
        
        dismiss(animated: true, completion: nil)
    }

}
