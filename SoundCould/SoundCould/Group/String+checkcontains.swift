//
//  String+contains.swift
//  SoundCould
//
//  Created by nguyen.van.bao on 04/06/2018.
//  Copyright © 2018 nguyen.van.bao. All rights reserved.
//

import Foundation
extension String {
    func checkcontains(find: String) -> Bool {
        return self.range(of: find) != nil
    }
}
