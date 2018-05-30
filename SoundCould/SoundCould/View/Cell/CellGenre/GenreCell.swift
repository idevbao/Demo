//
//  GenreCell.swift
//  SoundCould
//
//  Created by nguyen.van.bao on 18/05/2018.
//  Copyright © 2018 nguyen.van.bao. All rights reserved.
//

import UIKit

class GenreCell: UICollectionViewCell {
    @IBOutlet private weak var imgCellListGenre: UIImageView!
    @IBOutlet private weak var lblSongTitle: UILabel!
    @IBOutlet private weak var lblSinger: UILabel!

    func setUIPlay(dataTrack: DataTrack) {
        guard let link = dataTrack.artworkUrl else {
            return
        }
        self.imgCellListGenre.setImageFromURL(urlLink: link)
        self.lblSongTitle.text = dataTrack.title
        self.lblSinger.text = dataTrack.userName
    }
}
