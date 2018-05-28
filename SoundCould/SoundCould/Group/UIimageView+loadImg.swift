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
        let newUrl = urlLink.replacingOccurrences(of: "large.jpg", with: "t500x500.jpg", options: .literal, range: nil)
        guard let url = URL(string: newUrl) else {
            return
        }
        self.kf.setImage(with: url)
    }
}
