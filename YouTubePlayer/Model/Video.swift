//
//  Video.swift
//  YouTubePlayer
//
//  Created by John Lima on 5/27/16.
//  Copyright © 2016 limadeveloper. All rights reserved.
//

import UIKit

class Video: NSObject {

    var videoId: String?
    var videoTitle: String?
    var videoDescription: String?
    var videoThumbnailUrl: String?
    var videoThumbnailSize: (width: CGFloat, height: CGFloat) = (480.0, 344.0)
}
