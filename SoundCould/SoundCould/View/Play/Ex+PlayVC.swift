//
//  Ex+PlayVC.swift
//  SoundCould
//
//  Created by nguyen.van.bao on 04/06/2018.
//  Copyright © 2018 nguyen.van.bao. All rights reserved.
//

import Foundation
extension PlayViewController {
     func timeFormat(time: Float) -> String {
        let min = Int(time / 60)
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        return "\(min):\(sec)"
    }
    
     func mathPlayLikeCount(number: Int) -> String {
        var resultCount: String!
        var key = 1000
        var result = number / key
        if number < key {
            resultCount = "\(number)"
        } else if result < key && result > 0 {
            resultCount = "\(result)K"
        } else {
            let tam = result % key
            result /= 1000
            key *= 1000
            if result < key && result > 0 {
                resultCount = "\(result)M\(tam)"
            }
        }
        return resultCount
    }
}
