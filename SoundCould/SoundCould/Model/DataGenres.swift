//
//  DataGenres.swift
//  SoundCould
//
//  Created by nguyen.van.bao on 17/05/2018.
//  Copyright © 2018 nguyen.van.bao. All rights reserved.
//

import UIKit
import ObjectMapper

class DataGenres: Mappable {
    var id: Int?
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        id <- map["track.id"]
    }
}
