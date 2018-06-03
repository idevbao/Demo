//
//  CoreDBManager.swift
//  SoundCould
//
//  Created by nguyen.van.bao on 03/06/2018.
//  Copyright © 2018 nguyen.van.bao. All rights reserved.
//

import Foundation
import CoreData

class CoreDBManager {
    class var sharedInstance: CoreDBManager {
        struct Static {
            static let instance = CoreDBManager()
        }
        return Static.instance
    }
    
    func isExist(nameTrack: String) -> NSManagedObject? {
        var tracks = [NSManagedObject]()
        let managerViewContext =  AppDelegate.share.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tracks")
        do {
            tracks = try managerViewContext.fetch(fetchRequest)
            for item in tracks {
                let name = item.value(forKeyPath: "nameTrack") as? String
                if name == String(nameTrack) {
                    return item
                }
            }
        } catch {
            return nil
        }
        return nil
    }
    
    func insertTrack(
                    imgPath: String,
                    trackPath: String,
                    nameSinger: String,
                    titleTrack: String,
                    completion: @escaping(_ isInserted: Bool) -> Void) {
        let managerViewContext =  AppDelegate.share.persistentContainer.viewContext
        let newTrack = NSEntityDescription.insertNewObject(forEntityName: "Tracks",
                                                          into: managerViewContext)

        newTrack.setValue(nameSinger, forKey: "nameSinger")
        newTrack.setValue(titleTrack, forKey: "nameTrack")
        newTrack.setValue(trackPath, forKey: "urlTrack")
        newTrack.setValue(imgPath, forKey: "urlIMG")

        do {
            try managerViewContext.save()
            completion(true)
        } catch let error {
            print("Could not save. Error: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func getArrayTrack() -> [DataTrack] {
        var tracks = [DataTrack]()
        let managerViewContext =  AppDelegate.share.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tracks")
        do {
            let coreDataTracks = try managerViewContext.fetch(fetchRequest)
            for item in coreDataTracks {
                let track = DataTrack(title: item.value(forKey: "nameTrack") as? String ?? " ",
                                      userName: item.value(forKey: "nameSinger") as? String ?? " ",
                                      artworkUrl: item.value(forKey: "urlIMG") as? String ?? "",
                                      streamUrl: item.value(forKey: "urlTrack") as? String ?? "")
                tracks.append(track)
            }
        } catch {
        }
        return tracks
    }
}
