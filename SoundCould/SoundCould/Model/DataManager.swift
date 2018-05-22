//
//  DataManager.swift
//  SoundCould
//
//  Created by nguyen.van.bao on 17/05/2018.
//  Copyright © 2018 nguyen.van.bao. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    static let sharedInstance = DataManager()
    var dicIDGenre = [String: [DataGenres]] ()
    var dicTrackGenre = [String: [DataTrack]] ()
    
    func getDataID(arrayGenre: [String], quantity: Int,
                   completion: @escaping ([String: [DataTrack]]?) -> Void ) {
        for name in arrayGenre {
            let url = "\(Key.link)\(name)\(Key.key)\(quantity)"
            guard let urllink = URL(string: url) else {
                completion(nil)
                return
            }
            URLSessionAPI.getData(url: urllink) {[weak self] (data, err) in
                guard let dataRequest = data, err == nil else {
                    print("API Get data fail ")
                    completion(nil)
                    return
                }
                do {
                    guard let jsonDictionary = try JSONSerialization.jsonObject(
                        with: dataRequest,
                        options: JSONSerialization.ReadingOptions.mutableContainers)
                        as? [String: AnyObject] else {
                            completion(nil)
                            return
                    }
                    guard let jsonArray = jsonDictionary[ "collection" ]  as? [[String: AnyObject]] else {
                        completion(nil)
                        return
                    }
                    var itemID = [Int]()
                    for items in jsonArray {
                        guard let item = DataGenres(JSON: items)?.id else {
                            completion(nil)
                            return
                        }
                        itemID.append(item)
                    }
                    self?.getDataTrack(arrID: itemID, name: name, completionHandler: {[weak self] (data) in
                        completion(data)
                    })
                } catch {
                    print("Pass [myData] Fail")
                    completion(nil)
                }
            }
        }
    }
    
    func getDataTrack(arrID: [Int], name: String, completionHandler: @escaping ([String: [DataTrack]]?) -> Void ) {
        DispatchQueue.global(qos: .userInitiated).async {
            let downloadGroup = DispatchGroup()
            var songs = [DataTrack]()
            for id in arrID {
                guard let urllink = URL(string: "\(Key.linkTrack)\(id)\(Key.keyTrack)") else {
                    completionHandler(nil)
                    return
                }
                downloadGroup.enter()
                URLSessionAPI.getData(url: urllink) {(data, err) in
                    guard let dataRequest = data, err == nil else {
                        downloadGroup.leave()
                        completionHandler(nil)
                        print("URLSessionAPI  get  data fail ")
                        return
                    }
                    do {
                        let jsonArray = try JSONSerialization.jsonObject(with: dataRequest,
                                                                         options:
                            JSONSerialization.ReadingOptions.mutableContainers)
                        guard let items = jsonArray as? [String: AnyObject] else {
                            completionHandler(nil)
                            downloadGroup.leave()
                            return
                        }
                        guard let item = DataTrack(JSON: items) else {
                            completionHandler(nil)
                            downloadGroup.leave()
                            return
                        }
                        songs.append(item)
                        downloadGroup.leave()
                    } catch {
                        completionHandler(nil)
                        downloadGroup.leave()
                        print("Pass  GetDataTrack [myData] Fail")
                    }
                }
            }
            downloadGroup.wait()
            DispatchQueue.main.async {
                self.dicTrackGenre.updateValue(songs, forKey: name)
                completionHandler(self.dicTrackGenre)
            }
        }
    }
}
