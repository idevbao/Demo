//
//  MusicOffCell.swift
//  SoundCould
//
//  Created by nguyen.van.bao on 03/06/2018.
//  Copyright © 2018 nguyen.van.bao. All rights reserved.
//

import UIKit

class MusicOffCell: UITableViewCell {

    @IBOutlet private weak var nameSinger: UILabel!
    @IBOutlet private weak var titleSong: UILabel!
    @IBOutlet private weak var imgViewCellMusicOff: UIImageView!
   
    func setUIMusicOffCell(dataTrack: DataTrack) {
        guard let title = dataTrack.title, let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                                          .userDomainMask, true).first else {
            return
        }
        let fileName = title + ".jpg"
        let image = UIImage(contentsOfFile: path + "/" + fileName)
        self.imgViewCellMusicOff.image = image
        self.titleSong.text = dataTrack.title
        self.nameSinger.text = dataTrack.userName
    }
}
