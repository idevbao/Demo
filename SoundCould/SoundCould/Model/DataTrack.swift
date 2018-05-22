//
//  DataTrack.swift
//  SoundCould
//
//  Created by nguyen.van.bao on 17/05/2018.
//  Copyright © 2018 nguyen.van.bao. All rights reserved.
//

import UIKit
import ObjectMapper

class DataTrack: Mappable {
    var playbackCount: Int?
    var title: String?
    var userName: String?
    var downloadUrl: String?
    var streamUrl: String?
    var artworkUrl: String?
    var favoritingsCount: Int?
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        playbackCount <- map["playback_count"]
        title <- map["title"]
        userName <- map["user.username"]
        downloadUrl <- map["download_url"]
        artworkUrl <- map["artwork_url"]
        streamUrl <- map["stream_url"]
        favoritingsCount <- map["favoritings_count"]
    }
}
