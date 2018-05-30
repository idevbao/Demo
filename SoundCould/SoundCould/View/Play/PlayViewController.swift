//
//  PlayViewController.swift
//  SoundCould
//
//  Created by nguyen.van.bao on 19/05/2018.
//  Copyright © 2018 nguyen.van.bao. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import AVKit

class PlayViewController: UIViewController, AVAudioPlayerDelegate {
    @IBOutlet private weak var btnRepLay: UIButton!
    @IBOutlet private weak var btnOutPlay: UIButton!
    @IBOutlet private weak var imgBackgoundPlay: UIImageView!
    @IBOutlet private weak var trackTitle: UILabel!
    @IBOutlet private weak var singerName: UILabel!
    @IBOutlet private weak var lblPlayCount: UILabel!
    @IBOutlet private weak var lblLikeCount: UILabel!

    var player = AVPlayer()
    let timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapOutScreenPlay(_ sender: UIButton) {
        self.dismiss(animated: true)
        let audiSession = AVAudioSession.sharedInstance()
        do {
            try audiSession.setCategory(AVAudioSessionCategoryPlayback)
        } catch {
        }
    }

    @IBAction func tapReplayTrack(_ sender: UIButton) {
    }

    @IBAction func tapDowTrack(_ sender: UIButton) {
    }

    @IBAction func btnPlay(_ sender: UIButton) {
        player.play()
    }

    @IBAction func btnBack(_ sender: UIButton) {
    }

    @IBAction func btnNext(_ sender: UIButton) {
    }

    func setUIPlay(dataTrack: DataTrack) {
        guard let link =  dataTrack.artworkUrl else {
            return
        }
        self.imgBackgoundPlay.setImageFromURL(urlLink: link)
        self.trackTitle.text = dataTrack.title
        self.singerName.text = dataTrack.userName
        self.lblLikeCount.text = "\(String(describing: dataTrack.favoritingsCount))"
        self.lblPlayCount.text = "\(String(describing: dataTrack.playbackCount))"
        guard let url = dataTrack.streamUrl else {
            return
        }
        print(url)

    }
}
