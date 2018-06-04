//
//  GenreViewController.swift
//  SoundCould
//
//  Created by nguyen.van.bao on 18/05/2018.
//  Copyright © 2018 nguyen.van.bao. All rights reserved.
//

import UIKit

class GenreViewController: UIViewController {
    @IBOutlet private weak var collectionGenre: UICollectionView!
    var nameGrenre = ""
    var dataSong = [String: [DataTrack]]()
    var arrTrackGenre = [DataTrack]()
    var dataManager = DataManager()
    var quantitySong = Constant.quantityTrack
    var refreshControl = UIRefreshControl()
    var scrollBottom = UIActivityIndicatorView()
    let numberTrack = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTrack()
        configGenre()
    }
    
    private func configGenre() {
        self.collectionGenre.addSubview(refreshControl)
        self.refreshControl.addTarget(self, action: #selector(self.refreshCollectiomView), for: .valueChanged)
        scrollBottom.hidesWhenStopped = true
        scrollBottom.center = self.view.center
        scrollBottom.activityIndicatorViewStyle = .gray
        scrollBottom.transform = CGAffineTransform(scaleX: 3, y: 3)
        settingNavi()
    }
    
    @objc func refreshCollectiomView() {
        quantitySong += numberTrack
        loadTrack()
    }
    
   private func settingNavi() {
        self.navigationController?.navigationBar.topItem?.title = " SoundCloud "
        self.navigationController?.navigationBar.tintColor = .orange
        self.navigationController?.navigationBar.backgroundColor = .white
        self.view.addSubview(scrollBottom)
    }
}

extension GenreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTrackGenre.isEmpty ? Constant.numberInSection : arrTrackGenre.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
        UICollectionViewCell {
            guard let cell: GenreCell = collectionGenre.dequeueReusableCell(withReuseIdentifier: "cell",
                                                                            for: indexPath) as? GenreCell else {
                                                                                return UICollectionViewCell()
            }
            if !arrTrackGenre.isEmpty {
                cell.setUIPlay(dataTrack: arrTrackGenre[indexPath.row])
            }
            return cell
    }
}

extension GenreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((self.view.frame.width - 2 * Constant.marginCollectionView) / 2),
                      height: self.view.frame.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 05, left: 05, bottom: 05, right: 05)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.minimumSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.minimumSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !arrTrackGenre.isEmpty {
            let playViewController = PlayViewController(nibName: "PlayViewController", bundle: nil)
            self.present(playViewController, animated: false, completion: nil)
            playViewController.setUIPlay(dataTrack: arrTrackGenre[indexPath.row], arrDataSongs: arrTrackGenre)
            scrollBottom.stopAnimating()
        } else {
            scrollBottom.startAnimating()
        }
    }
    
    private func updateNextSet() {
        quantitySong += numberTrack
        loadTrack()
    }
    
    private func loadTrack() {
        dataManager.getDataID(arrayGenre: [nameGrenre], quantity: quantitySong) { [weak self] (data) in
            DispatchQueue.main.async {
                guard let `self` = self, let dataSong = data,
                    let arrSong = dataSong[self.nameGrenre] else { return }
                self.arrTrackGenre = arrSong
                self.refreshControl.endRefreshing()
                self.scrollBottom.stopAnimating()
                self.collectionGenre.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == arrTrackGenre.count - 1 {
            quantitySong += numberTrack
            scrollBottom.startAnimating()
            loadTrack()
        }
    }
}
