//
//  DataManager.swift
//  SoundCould
//
//  Created by nguyen.van.bao on 17/05/2018.
//  Copyright © 2018 nguyen.van.bao. All rights reserved.
//

import UIKit
import Alamofire

class DataManager: NSObject {
    static let sharedInstance = DataManager()
    var dicIDGenre = [String: [DataGenres]] ()
    var dicTrackGenre = [String: [DataTrack]] ()
    var params = [String: Any]()
    func getDataID(arrayGenre: [String], quantity: Int,
                   completion: @escaping ([String: [DataTrack]]?) -> Void ) {
        for name in arrayGenre {
            params = ["kind": Key.kind, "genre": "\(Key.genre)\(name)",
                "client_id": Key.clientId, "limit": quantity]
            Alamofire.request(Key.path, method: .get, parameters: params,
                              encoding: URLEncoding.default, headers: nil).responseJSON { [weak self] response in
                                guard let `self` = self else {
                                    return
                                }
                                switch response.result {
                                case .success:
                                    guard let jsonDictionary = response.value as? [String: Any] else {
                                        completion(nil)
                                        return
                                    }
                                    guard let jsonArray = jsonDictionary["collection"] as? [[String: AnyObject]]  else {
                                        completion(nil)
                                        return
                                    }
                                    var itemID = [Int]()
                                    for item in jsonArray {
                                        guard let item = DataGenres(JSON: item)?.id else {
                                            completion(nil)
                                            return
                                        }
                                        itemID.append(item)
                                    }
                                    self.getDataTrack(arrIdTrack: itemID, name: name, completionHandler: {(data) in
                                        completion(data)
                                    })
                                case .failure:
                                    completion(nil)
                                }
                                
            }
        }
    }
    
    func getDataTrack(arrIdTrack: [Int], name: String, completionHandler: @escaping ([String: [DataTrack]]?) -> Void ) {
        DispatchQueue.global(qos: .userInitiated).async {
            let downloadGroup = DispatchGroup()
            var songs = [DataTrack]()
            for id in arrIdTrack {
                downloadGroup.enter()
                let pathsong = "\(Key.pathTrack)\(id)"
                let paramsong = ["client_id": Key.clientId]
                Alamofire.request(pathsong, method: .get, parameters: paramsong,
                                  encoding: URLEncoding.default, headers: nil).responseJSON { response in
                                    switch response.result {
                                    case .success:
                                        guard let jsonDictionary = response.value as? [String: Any] else {
                                            downloadGroup.leave()
                                            completionHandler(nil)
                                            return
                                        }
                                        guard let item = DataTrack(JSON: jsonDictionary) else {
                                            downloadGroup.leave()
                                            completionHandler(nil)
                                            return
                                        }
                                        songs.append(item)
                                        downloadGroup.leave()
                                        
                                    case .failure(let error):
                                        print(error)
                                        downloadGroup.leave()
                                    }
                }
            }
            downloadGroup.wait()
            DispatchQueue.main.async {[weak self] in
                guard let `self` = self else {
                    return
                }
                self.dicTrackGenre.updateValue(songs, forKey: name)
                completionHandler(self.dicTrackGenre)
            }
            
        }
    }
}
