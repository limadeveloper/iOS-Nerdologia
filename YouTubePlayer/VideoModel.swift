//
//  VideoModel.swift
//  YouTubePlayer
//
//  Created by John Lima on 5/27/16.
//  Copyright © 2016 John Lima. All rights reserved.
//

import UIKit
import Alamofire

protocol VideoModelDelegate {
    func dataReady()
}

class VideoModel: NSObject {

    fileprivate let API_KEY = "AIzaSyCY8dW_4IoTb-FG3ZzZ7pOaUp7U1unfN7E"
    fileprivate let URL_STRING = "https://www.googleapis.com/youtube/v3/playlistItems"
    fileprivate let MAX_RESULTS = 50
    
    var videoArray = [Video]()
    
    var delegate: VideoModelDelegate?
    
    func getFeedVideos(playListId: String) {
        
        Alamofire.request(.GET, URL_STRING, parameters: ["part": "snippet", "playlistId": playListId, "key": API_KEY, "maxResults": MAX_RESULTS], encoding: .URL, headers: nil).responseJSON { (response) in
            
            if let json = response.result.value {
                
                var arrayVideos = [Video]()
                
                if let json = json["items"] as? NSArray {
                    print(json)
                
                    for video in json {
                        
                        let videoObject = Video()
                        
                        if let id = video.valueForKeyPath("snippet.resourceId.videoId") as? String {
                            videoObject.videoId = id
                        }
                        
                        if let title = video.valueForKeyPath("snippet.title") as? String {
                            videoObject.videoTitle = title
                        }
                        
                        if let description = video.valueForKeyPath("snippet.description") as? String {
                            videoObject.videoDescription = description
                        }
                        
                        if let thumbnailUrl = video.valueForKeyPath("snippet.thumbnails.maxres.url") as? String, let width = video.valueForKeyPath("snippet.thumbnails.maxres.width") as? CGFloat, let height = video.valueForKeyPath("snippet.thumbnails.maxres.height") as? CGFloat {
                            videoObject.videoThumbnailUrl = thumbnailUrl
                            videoObject.videoThumbnailSize = (width, height)
                        }else {
                            if let thumbnailUrl = video.valueForKeyPath("snippet.thumbnails.standard.url") as? String, let width = video.valueForKeyPath("snippet.thumbnails.standard.width") as? CGFloat, let height = video.valueForKeyPath("snippet.thumbnails.standard.height") as? CGFloat {
                                videoObject.videoThumbnailUrl = thumbnailUrl
                                videoObject.videoThumbnailSize = (width, height)
                            }else {
                                if let thumbnailUrl = video.valueForKeyPath("snippet.thumbnails.high.url") as? String, let width = video.valueForKeyPath("snippet.thumbnails.high.width") as? CGFloat, let height = video.valueForKeyPath("snippet.thumbnails.high.height") as? CGFloat {
                                    videoObject.videoThumbnailUrl = thumbnailUrl
                                    videoObject.videoThumbnailSize = (width, height)
                                }else {
                                    if let thumbnailUrl = video.valueForKeyPath("snippet.thumbnails.medium.url") as? String, let width = video.valueForKeyPath("snippet.thumbnails.medium.width") as? CGFloat, let height = video.valueForKeyPath("snippet.thumbnails.medium.height") as? CGFloat {
                                        videoObject.videoThumbnailUrl = thumbnailUrl
                                        videoObject.videoThumbnailSize = (width, height)
                                    }else {
                                        if let thumbnailUrl = video.valueForKeyPath("snippet.thumbnails.default.url") as? String, let width = video.valueForKeyPath("snippet.thumbnails.default.width") as? CGFloat, let height = video.valueForKeyPath("snippet.thumbnails.default.height") as? CGFloat {
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
                
                self.videoArray = arrayVideos
                
                if self.delegate != nil {
                    self.delegate!.dataReady()
                }
            }
            
        }
        
    }
    
}
