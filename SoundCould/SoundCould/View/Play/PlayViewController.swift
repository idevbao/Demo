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
import MediaPlayer

class PlayViewController: UIViewController {
    
    @IBOutlet private weak var btnPlay: UIButton!
    @IBOutlet private weak var btnNext: UIButton!
    @IBOutlet private weak var btnBack: UIButton!
    @IBOutlet private weak var sliderAudio: UISlider!
    @IBOutlet private weak var timeCurrent: UILabel!
    @IBOutlet private weak var btnDown: UIButton!
    @IBOutlet private weak var btnRepLay: UIButton!
    @IBOutlet private weak var btnOutPlay: UIButton!
    @IBOutlet private weak var imgBackgoundPlay: UIImageView!
    @IBOutlet private weak var trackTitle: UILabel!
    @IBOutlet private weak var singerName: UILabel!
    @IBOutlet private weak var lblPlayCount: UILabel!
    @IBOutlet private weak var lblLikeCount: UILabel!
    @IBOutlet private weak var timeCompletion: UILabel!
    enum LoopSong: Int {
        case nonLoop = 0
        case loopOne = 1
        case loopAll = 2
        case shuffle = 3
    }
    var arrDataSong = [DataTrack]()
    var player: AVPlayer?
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    var indexSong = 0
    var isPlay = false
    var activityLoad  = UIActivityIndicatorView()
    var loopPlaySong = LoopSong.nonLoop
    var isDownload = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configPlayView()
        self.playBackground()
    }
    
    @IBAction func tapOutScreenPlay(_ sender: UIButton) {
        player?.pause()
        player = nil
        self.dismiss(animated: true)
    }
    
    @IBAction func tapReplayTrack(_ sender: UIButton) {
        switch loopPlaySong {
        case .shuffle:
            loopPlaySong = .nonLoop
            self.settingButton(index: indexSong)
            self.btnRepLay.setImage(UIImage(named: "like"), for: .normal)
            print(loopPlaySong)
        case .loopOne:
            loopPlaySong = .loopAll
            self.settingButton(index: indexSong)
            self.btnRepLay.setImage(UIImage(named: "loopall"), for: .normal)
            print(loopPlaySong)
        case .loopAll:
            loopPlaySong = .shuffle
            self.settingButton(index: indexSong)
            self.btnRepLay.setImage(UIImage(named: "random"), for: .normal)
            print(loopPlaySong)
        case .nonLoop:
            loopPlaySong = .loopOne
            self.settingButton(index: indexSong)
            self.btnRepLay.setImage(UIImage(named: "loopone"), for: .normal)
            print(loopPlaySong)
        }   
    }
    
    @IBAction func tapDowTrack(_ sender: UIButton) {
    }
    
    @IBAction func btnPlay(_ sender: UIButton) {
        if isPlay {
            if self.sliderAudio.value == 0 && indexSong == arrDataSong.count - 1 {
                self.setUI(dataTrack: arrDataSong[indexSong])
            }
            isPlay = false
            self.btnPlay.setBackgroundImage(UIImage(named: "stop"), for: .normal)
            self.player?.play()
        } else {
            self.player?.pause()
            isPlay = true
            self.btnPlay.setBackgroundImage(UIImage(named: "Play"), for: .normal)
        }
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.backSong()
    }
    
    @IBAction func btnNext(_ sender: UIButton) {
        self.nextSong()
    }
    
    @IBAction func sliderAction(_ sender: Any) {
        isPlay = false
        self.btnPlay.setBackgroundImage(UIImage(named: "stop"), for: .normal)
        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,
                                          selector: #selector(self.getCurrentime), userInfo: nil, repeats: true)
        let timeinSecond = sliderAudio.value
        self.player?.play()
        let cmtime = CMTimeMake(Int64(timeinSecond), 1)
        player?.seek(to: cmtime)
    }
    
    func setUI(dataTrack: DataTrack) {
        activityLoad.startAnimating()
        self.settingButton(isEnable: false)
        self.settingButton(index: indexSong)
        guard let dataLinkDownTrack = dataTrack.downloadUrl, let dataLinkDownImg = dataTrack.artworkUrl else {
            self.btnDown.isEnabled = false
            return
        }
        if self.btnDown.isEnabled == true {
            self.dowDataTrack(dataLinkdown: dataLinkDownTrack, dataTitle: dataLinkDownImg)
        }
        guard let link =  dataTrack.artworkUrl,
            let favoCount = dataTrack.favoritingsCount,
            let title = dataTrack.title,
            let name = dataTrack.userName,
            let playCount = dataTrack.playbackCount else {
                return
        }
        self.imgBackgoundPlay.setImageFromURL(urlLink: link)
        self.trackTitle.text = title
        self.singerName.text = name
        self.lblLikeCount.text = "\(self.mathPlayLikeCount(number: favoCount))"
        self.lblPlayCount.text = "\(self.mathPlayLikeCount(number: playCount))"
        guard let url = dataTrack.streamUrl else {
            return
        }
        guard let linkPlayer = URL(string: "\(url)\(Key.linkPlay)") else {
            return
        }
        let downloadSong = DispatchGroup()
        downloadSong.enter()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else {
                return
            }
            self.player = AVPlayer(url: linkPlayer)
            self.player?.play()
            downloadSong.leave()
            downloadSong.wait()
            DispatchQueue.main.async { [weak self] in
                guard let this = self, let getSeconds = (this.player?.currentItem?.asset.duration) else {
                    return
                }
                MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                    MPMediaItemPropertyTitle: title,
                    MPMediaItemPropertyArtist: name
                ]
                UIApplication.shared.beginReceivingRemoteControlEvents()
                this.becomeFirstResponder()
                this.btnPlay.setBackgroundImage(UIImage(named: "stop"), for: .normal)
                this.timeCompletion.text = this.timeFormat(time: Float(CMTimeGetSeconds(getSeconds)))
                this.sliderAudio.maximumValue = Float(CMTimeGetSeconds(getSeconds))
                this.timeCurrent.text = "0:0"
                this.timer?.invalidate()
                this.timer = nil
                this.timer = Timer.scheduledTimer(timeInterval: 0.01, target: this,
                                                  selector: #selector(this.getCurrentime), userInfo: nil, repeats: true)
                this.settingButton(isEnable: true)
                this.activityLoad.stopAnimating()
            }
        }
    }
}

extension PlayViewController {
    private func settingButton(index: Int?) {
        switch index {
        case 0:
            self.settingBtnBackNext(btn: btnBack)
        case arrDataSong.count - 1:
            self.settingBtnBackNext(btn: btnNext)
        default:
            btnNext.isHidden = false
            btnBack.isHidden = false
        }
    }
    private func settingBtnBackNext(btn: UIButton) {
        print(loopPlaySong)
        switch loopPlaySong {
        case LoopSong.loopOne:
            btn.isHidden = false
        case LoopSong.loopAll:
            btn.isHidden = false
        case LoopSong.shuffle:
            btn.isHidden = false
        default:
            btn.isHidden = false
        }
    }
    
    @objc func getCurrentime() {
        guard let valueTime = (player?.currentItem?.currentTime()),
            let getSconds = player?.currentItem?.currentTime(), let duration = player?.currentItem?.asset.duration
            else {
                return
        }
        self.sliderAudio.value = Float(CMTimeGetSeconds(valueTime))
        self.timeCurrent.text = self.timeFormat(time: Float(CMTimeGetSeconds(getSconds)))
        self.timeCompletion.text =  self.timeFormat(time: Float(CMTimeGetSeconds((duration) - getSconds)))
        if self.timeCompletion.text == "0:0" {
            self.player?.pause()
            self.timer?.invalidate()
            self.timer = nil
            self.btnPlay.setBackgroundImage(UIImage(named: "Play"), for: .normal)
            self.isPlay = false
            self.audioPlayer?.currentTime = 0.0
            self.timeCompletion.text = "0:0"
            self.timeCurrent.text = "0:0"
            self.sliderAudio.value = 0.0
            self.checkStatusButtonFinishSong()
        }
    }
    
    private func timeFormat(time: Float) -> String {
        let min = Int(time / 60)
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        return "\(min):\(sec)"
    }
    
    func setUIPlay(dataTrack: DataTrack, arrDataSongs: [DataTrack]) {
        arrDataSong = arrDataSongs
        for (index, item) in arrDataSongs.enumerated() where item.userName == dataTrack.userName {
            self.indexSong = index
        }
        self.setUI(dataTrack: dataTrack)
    }
    
    private func loopOne() {
        if indexSong == arrDataSong.count || indexSong < 0 {
            player = nil
            self.dismiss(animated: true)
        } else {
            self.setUI(dataTrack: arrDataSong[indexSong])
            print(indexSong)
        }
    }
    
     private func shuffleSong() {
        let randomIndex = Int(arc4random_uniform(UInt32(arrDataSong.count )))
        self.indexSong = randomIndex
        setUI(dataTrack: arrDataSong[randomIndex])
        print(indexSong)
    }
    
    private func nonLoopSong() {
        if indexSong == arrDataSong.count - 1 {
            self.player?.pause()
            isPlay = true
            player = nil
            self.dismiss(animated: true)
            print(indexSong)
        } else {
            self.indexSong = indexSong + 1
            self.setUI(dataTrack: arrDataSong[indexSong])
            print(indexSong)
        }
    }
    
    private func loopAll() {
        switch indexSong {
        case arrDataSong.count - 1:
            indexSong = 0
            self.setUI(dataTrack: arrDataSong[indexSong])
            print(indexSong)
        default:
            self.indexSong += 1
            self.setUI(dataTrack: arrDataSong[indexSong])
            print(indexSong)
        }
    }
    
    private func backAll() {
        switch indexSong {
        case 0:
            self.indexSong = arrDataSong.count - 1
            self.setUI(dataTrack: arrDataSong[indexSong])
            print(indexSong)
        default:
            self.indexSong -= 1
            self.setUI(dataTrack: arrDataSong[indexSong])
            print(indexSong)
        }
    }
    
    private func backnonLoopSong() {
        if indexSong == 0 {
            self.player?.pause()
            isPlay = true
            player = nil
            self.dismiss(animated: true)
            print(indexSong)
        } else {
            self.indexSong -= 1
            self.setUI(dataTrack: arrDataSong[indexSong])
            print(indexSong)
        }
    }
    
    private func backSong() {
        switch loopPlaySong {
        case LoopSong.shuffle:
            self.shuffleSong()
        case LoopSong.loopOne:
            self.indexSong -= 1
            self.loopOne()
        case LoopSong.loopAll:
            self.backAll()
        default:
            self.backnonLoopSong()
        }
    }
    
    private func nextSong() {
        switch loopPlaySong {
        case LoopSong.shuffle:
            self.shuffleSong()
        case LoopSong.loopOne:
            self.indexSong += 1
            self.loopOne()
        case LoopSong.loopAll:
            self.loopAll()
        default:
            self.nonLoopSong()
        }
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if let event = event {
            if event.type == .remoteControl {
                switch event.subtype {
                case .remoteControlPlay:
                    self.player?.play()
                case .remoteControlPause:
                    self.player?.pause()
                case .remoteControlNextTrack:
                    self.nextSong()
                case .remoteControlPreviousTrack:
                    self.backSong()
                default:
                    break
                }
            }
        }
    }
    
    private func configPlayView() {
        activityLoad.hidesWhenStopped = true
        activityLoad.activityIndicatorViewStyle = .white
        activityLoad.center = self.view.center
        activityLoad.transform = CGAffineTransform(scaleX: 10, y: 10)
        self.view.addSubview(activityLoad)
        self.btnRepLay.setImage(UIImage(named: "like"), for: .normal)
        self.btnPlay.setBackgroundImage(UIImage(named: "Play"), for: .normal)
        self.btnDown.isEnabled = false
        self.sliderAudio.setThumbImage(UIImage(named: "music_timeline"), for: .normal)
    }
    
    private func settingButton(isEnable: Bool) {
        btnNext.isEnabled = isEnable
        btnBack.isEnabled = isEnable
        sliderAudio.isEnabled = isEnable
        btnPlay.isEnabled = isEnable
    }
    
    private func dowDataTrack(dataLinkdown: String, dataTitle: String) {
        DataManager.sharedInstance.downloadTrack(urlTrack: dataLinkdown, nameTrack: dataTitle) { (data) in
        }
    }
    
    private func checkStatusButtonFinishSong() {
        switch loopPlaySong {
        case LoopSong.loopOne:
            self.loopOne()
        case LoopSong.shuffle:
            self.shuffleSong()
        case LoopSong.loopAll:
            self.loopAll()
        default:
            self.nonLoopSong()
        }
    }
    
    private func playBackground() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .defaultToSpeaker)
        } catch {
        }
    }
    private func mathPlayLikeCount(number: Int) -> String {
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
