//
//  MusicOffViewController.swift
//  SoundCould
//
//  Created by nguyen.van.bao on 03/06/2018.
//  Copyright © 2018 nguyen.van.bao. All rights reserved.
//

import UIKit

class MusicOffViewController: UIViewController, ProtocolLoadSongOFF {
   
    static let sharedInstance = MusicOffViewController()
    @IBOutlet weak var tableviewMusicOff: UITableView!

    var arrDataDownload = [DataTrack]()
    let numberItemInScreen: CGFloat = 5
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let playViewController = PlayViewController(nibName: "PlayViewController", bundle: nil)
        playViewController.delegateOff = self
        arrDataDownload = CoreDBManager.sharedInstance.getArrayTrack()
        tableviewMusicOff.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        congifListOFF()
    }
    func loadSongOff() {
        arrDataDownload = CoreDBManager.sharedInstance.getArrayTrack()
        tableviewMusicOff.reloadData()
    }   
}

extension MusicOffViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDataDownload.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let musicOffCell =
            tableviewMusicOff.dequeueReusableCell(withIdentifier: "MusicOffCell") as? MusicOffCell else {
            return UITableViewCell()
        }
        musicOffCell.setUIMusicOffCell(dataTrack: arrDataDownload[indexPath.row])
        return musicOffCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height / numberItemInScreen
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playViewController = PlayViewController(nibName: "PlayViewController", bundle: nil)
        self.present(playViewController, animated: false, completion: nil)
        playViewController.setUIPlay(dataTrack: arrDataDownload[indexPath.row], arrDataSongs: arrDataDownload)
    }
    func congifListOFF() {
        if !CoreDBManager.sharedInstance.getArrayTrack().isEmpty {
            arrDataDownload = CoreDBManager.sharedInstance.getArrayTrack()
        }
    }
}

