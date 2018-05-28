//
//  UIimageView+loadImg.swift
//  SoundCould
//
//  Created by nguyen.van.bao on 21/05/2018.
//  Copyright © 2018 nguyen.van.bao. All rights reserved.
//

import UIKit
import Kingfisher
extension UIImageView {
    func setImageFromURL(urlLink: String) {
        guard let url = URL(string: urlLink)
            else {
                return
        }
        self.kf.setImage(with: url)
    }
}
