//
//  Video.swift
//  YouTubePlayer
//
//  Created by John Lima on 5/27/16.
//  Copyright © 2016 John Lima. All rights reserved.
//

import UIKit

class Video: NSObject {

    var videoId: String = String()
    var videoTitle: String = String()
    var videoDescription: String = String()
    var videoThumbnailUrl: String = String()
    var videoThumbnailSize: (width: CGFloat, height: CGFloat) = (480.0, 344.0)
}
