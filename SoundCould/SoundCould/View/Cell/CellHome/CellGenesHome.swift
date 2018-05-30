//  CellGenesHome.swift
//  SoundCould
//
//  Created by nguyen.van.bao on 18/05/2018.
//  Copyright © 2018 nguyen.van.bao. All rights reserved.
//

import UIKit
protocol ProtocolCellGene: class {
    func didSelectItemAtCellGrense(dataSong: DataTrack, arr: [DataTrack])
}

class CellGenesHome: UITableViewCell {
    @IBOutlet private weak var myCollectionView: UICollectionView!
    weak var delegate: ProtocolCellGene?
    var arrSongs: [DataTrack] = [] {
        didSet {
            self.myCollectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.myCollectionView.delegate = self
        self.myCollectionView.dataSource = self
        let customCellName = UINib(nibName: "CellSongGenes", bundle: nil)
        self.myCollectionView.register(customCellName, forCellWithReuseIdentifier: "CellSongGenes")
    }
}

extension CellGenesHome: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !arrSongs.isEmpty {
            return self.arrSongs.count
        }
        return Constant.numberInSection
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt
        indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "CellSongGenes", for: indexPath)
            as? CellSongGenes else {
                return UICollectionViewCell()
        }
        if  !arrSongs.isEmpty {
            cell.setUIPlay(dataTrack: arrSongs[indexPath.row])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = delegate, !arrSongs.isEmpty else {
            print("data nil")
            return
        }
        delegate.didSelectItemAtCellGrense(dataSong: arrSongs[ indexPath.row ], arr: arrSongs)
    }
}

extension CellGenesHome: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((self.contentView.frame.width -
            4 * Constant.marginCollectionView)/2) - Constant.marginCollectionView,
                      height: contentView.frame.height - 2 * Constant.marginCollectionView)
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
}
