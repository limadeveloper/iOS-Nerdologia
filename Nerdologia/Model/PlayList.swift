//
//  PlayList.swift
//  Nerdologia
//
//  Created by John Lima on 5/28/16.
//  Copyright © 2016 limadeveloper. All rights reserved.
//

import UIKit

enum KeyPlayListId: String {
    case Selected = "KEY_SELECTED"
}

struct PlayList {
    var playListIndex: Int
    var playlistName: String
    var playListId: String
}

extension PlayList {
    static func getPlayList() -> [PlayList] {
        return [
            PlayList(playListIndex: 1, playlistName: "Física", playListId: "PLyRcl7Q37-DUlJKeG5cks_deXdXjUEx1-"),
            PlayList(playListIndex: 2, playlistName: "Química", playListId: "PLyRcl7Q37-DWLbHCmcRq7JA6HLKUz5vds"),
            PlayList(playListIndex: 3, playlistName: "Biologia", playListId: "PLyRcl7Q37-DV52hO_mN0YQ8IX7DMrpgaF"),
            PlayList(playListIndex: 4, playlistName: "Engenharia", playListId: "PLyRcl7Q37-DUgAqJl3Z7aALEngFamHy80"),
            PlayList(playListIndex: 5, playlistName: "Tecnologia", playListId: "PLyRcl7Q37-DVa6NdvC4E4SFg8AzNquqvl"),
            PlayList(playListIndex: 6, playlistName: "Geologia", playListId: "PLyRcl7Q37-DVuiQp8ysAb2hB6csv532fd"),
            PlayList(playListIndex: 7, playlistName: "Psicologia", playListId: "PLyRcl7Q37-DUKZL1fxMb1uNX9IrpX2rjg"),
            PlayList(playListIndex: 8, playlistName: "Astronomia", playListId: "PLyRcl7Q37-DXmfJ38-ag6g8Xq8L7dZY8_"),
            PlayList(playListIndex: 9, playlistName: "Ecologia", playListId: "PLyRcl7Q37-DUM5Fx1DqYEfxfnjNvNfnPL"),
            PlayList(playListIndex: 10, playlistName: "Historia", playListId: "PLyRcl7Q37-DXmpJEy_fj-HnWtvHuu_Ihi"),
            PlayList(playListIndex: 11, playlistName: "Social", playListId: "PLyRcl7Q37-DXg4_JGNJO6RrVh7bMNpMJk")
        ]
    }
}
