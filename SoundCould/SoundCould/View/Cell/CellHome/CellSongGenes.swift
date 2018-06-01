//
//  CellSongGenes.swift
//  SoundCould
//
//  Created by nguyen.van.bao on 18/05/2018.
//  Copyright © 2018 nguyen.van.bao. All rights reserved.
//

import UIKit

class CellSongGenes: UICollectionViewCell {
    @IBOutlet private weak var imgViewCell: UIImageView!
    @IBOutlet private weak var lblTilte: UILabel!
    @IBOutlet private weak var lblSinger: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setUIPlay(dataTrack: DataTrack) {
        guard let link =  dataTrack.artworkUrl else {
            return
        }
        self.imgViewCell.setImageFromURL(urlLink: link)
        self.lblTilte.text = dataTrack.title
        self.lblSinger.text = dataTrack.userName
    }
}
