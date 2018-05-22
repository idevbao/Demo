//
//  URLSessionAPI.swift
//  SoundCould
//
//  Created by nguyen.van.bao on 17/05/2018.
//  Copyright © 2018 nguyen.van.bao. All rights reserved.
//

import UIKit

class URLSessionAPI: NSObject {
    public static func getData(url: URL, completion: @escaping(Data?, Error?) -> Void ) {
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            completion(data, err)
            }.resume()
    }
}
