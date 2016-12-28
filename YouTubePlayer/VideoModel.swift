//
//  VideoModel.swift
//  YouTubePlayer
//
//  Created by John Lima on 5/27/16.
//  Copyright © 2016 limadeveloper. All rights reserved.
//

import UIKit
import Alamofire

typealias DictionaryType = Dictionary<String, Any>
typealias ArrayType = [Dictionary<String, Any>]

protocol VideoModelDelegate {
    func dataReady()
}

private enum Key: String {
    case items = "items"
    case videoId = "snippet.resourceId.videoId"
    case title = "snippet.title"
    case description = "snippet.description"
    case maxresUrl = "snippet.thumbnails.maxres.url"
    case maxresWidth = "snippet.thumbnails.maxres.width"
    case maxresHeight = "snippet.thumbnails.maxres.height"
    case standardUrl = "snippet.thumbnails.standard.url"
    case standardWidth = "snippet.thumbnails.standard.width"
    case standardHeight = "snippet.thumbnails.standard.height"
    case highUrl = "snippet.thumbnails.high.url"
    case highWidth = "snippet.thumbnails.high.width"
    case highHeight = "snippet.thumbnails.high.height"
    case mediumUrl = "snippet.thumbnails.medium.url"
    case mediumWidth = "snippet.thumbnails.medium.width"
    case mediumHeight = "snippet.thumbnails.medium.height"
    case defaultUrl = "snippet.thumbnails.default.url"
    case defaultWidth = "snippet.thumbnails.default.width"
    case defaultHeight = "snippet.thumbnails.default.height"
}

class VideoModel: NSObject {

    fileprivate let API_KEY = "AIzaSyCY8dW_4IoTb-FG3ZzZ7pOaUp7U1unfN7E"
    fileprivate let URL_STRING = "https://www.googleapis.com/youtube/v3/playlistItems"
    fileprivate let MAX_RESULTS = 50
    
    var videoArray = [Video]()
    var delegate: VideoModelDelegate?
    
    func getFeedVideos(playListId: String) {
        
        let parameters: DictionaryType = ["part": "snippet", "playlistId": playListId, "key": API_KEY, "maxResults": MAX_RESULTS]
        
        Alamofire.request(URL_STRING, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { [weak self] (response) in
         
            if let json = response.result.value as? DictionaryType {
                
                var arrayVideos = [Video]()
                
                if let json = json[Key.items.rawValue] as? ArrayType {
                    
                    for video in json {
                        
                        let videoObject = Video()
                        
                        if let id = video.value(forKeyPath: Key.videoId.rawValue) as? String {
                            videoObject.videoId = id
                        }
                        if let title = video.value(forKeyPath: Key.title.rawValue) as? String {
                            videoObject.videoTitle = title
                        }
                        if let description = video.value(forKeyPath: Key.description.rawValue) as? String {
                            videoObject.videoDescription = description
                        }
                        
                        if  let thumbnailUrl = video.value(forKeyPath: Key.maxresUrl.rawValue) as? String,
                            let width = video.value(forKeyPath: Key.maxresWidth.rawValue) as? CGFloat,
                            let height = video.value(forKeyPath: Key.maxresHeight.rawValue) as? CGFloat {
                                videoObject.videoThumbnailUrl = thumbnailUrl
                                videoObject.videoThumbnailSize = (width, height)
                        }else {
                            if  let thumbnailUrl = video.value(forKeyPath: Key.standardUrl.rawValue) as? String,
                                let width = video.value(forKeyPath: Key.standardWidth.rawValue) as? CGFloat,
                                let height = video.value(forKeyPath: Key.standardHeight.rawValue) as? CGFloat {
                                    videoObject.videoThumbnailUrl = thumbnailUrl
                                    videoObject.videoThumbnailSize = (width, height)
                            }else {
                                if  let thumbnailUrl = video.value(forKeyPath: Key.highUrl.rawValue) as? String,
                                    let width = video.value(forKeyPath: Key.highWidth.rawValue) as? CGFloat,
                                    let height = video.value(forKeyPath: Key.highHeight.rawValue) as? CGFloat {
                                        videoObject.videoThumbnailUrl = thumbnailUrl
                                        videoObject.videoThumbnailSize = (width, height)
                                }else {
                                    if  let thumbnailUrl = video.value(forKeyPath: Key.mediumUrl.rawValue) as? String,
                                        let width = video.value(forKeyPath: Key.mediumWidth.rawValue) as? CGFloat,
                                        let height = video.value(forKeyPath: Key.mediumHeight.rawValue) as? CGFloat {
                                            videoObject.videoThumbnailUrl = thumbnailUrl
                                            videoObject.videoThumbnailSize = (width, height)
                                    }else {
                                        if  let thumbnailUrl = video.value(forKeyPath: Key.defaultUrl.rawValue) as? String,
                                            let width = video.value(forKeyPath: Key.defaultWidth.rawValue) as? CGFloat,
                                            let height = video.value(forKeyPath: Key.defaultHeight.rawValue) as? CGFloat {
                                                videoObject.videoThumbnailUrl = thumbnailUrl
                                                videoObject.videoThumbnailSize = (width, height)
                                        }
                                    }
                                }
                            }
                        }
                        
                        arrayVideos.append(videoObject)
                    }
                    
                }
                
                self?.videoArray = arrayVideos
                self?.delegate?.dataReady()
            }
        }
    }
    
    func getInfoVideoUrlBy(id: String) -> String {
        return "http://www.youtube.com/embed/\(id)?showinfo=0&modestbranding=1&frameborder=0&rel=0"
    }
    
}
