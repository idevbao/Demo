//
//  HomeViewController.swift
//  SoundCould
//
//  Created by nguyen.van.bao on 18/05/2018.
//  Copyright © 2018 nguyen.van.bao. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet private weak var homeTableView: UITableView!
    var dataTrack = [String: [DataTrack]] ()
    var arrayAllGenre = [String]()
    var dataManager = DataManager()
    var nameTitleGenre = [String]()
    let sizeFont: CGFloat = 35
    let sizeheightCell: CGFloat = 3.2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTitleGenre = ["Dance & EDM", "PoP", "R&B", "Alternative Rock", "County", "All - music", "All - Audio"]
        arrayAllGenre = ["danceedm", "pop", "alternativerock", "rbsoul", "country", "all-music", "all-audio"]
        
        dataManager.getDataID(arrayGenre: arrayAllGenre,
                              quantity: Constant.quantityTrack) { [weak self] (data) in
                                guard let `self` = self, let dataSong = data else {
                                    return
                                }
                                self.dataTrack = dataSong
                                DispatchQueue.main.async {
                                    self.homeTableView.reloadData()
                                }
        }
        self.configTableViewCell()
        configNaviBar()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = homeTableView.dequeueReusableCell(withIdentifier: "CellGenesHome") as? CellGenesHome else {
            return UITableViewCell()
        }
        let key = arrayAllGenre[indexPath.section]
        if let songs = dataTrack[key] {
            cell.arrSongs = songs
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.numberOfSections
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if !dataTrack.isEmpty {
            return self.dataTrack.count
        }
        return Constant.numberInSection
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height / sizeheightCell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Constant.heightForFooterInSection
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width:
            tableView.bounds.size.width,
            height: Constant.heightForHeaderInSection))
        headerView.backgroundColor = .white
        let btnShowListGenre = UIButton(frame: CGRect(x: 10, y: 5, width:
            tableView.bounds.size.width, height: Constant.btnShowListGenre))
        btnShowListGenre.setTitle("\(self.nameTitleGenre[section])", for: .normal)
        btnShowListGenre.titleLabel?.font = UIFont.boldSystemFont(ofSize: sizeFont)
        btnShowListGenre.setTitleColor(.black, for: .normal)
        btnShowListGenre.contentHorizontalAlignment = .left
        btnShowListGenre.tag = section
        btnShowListGenre.addTarget(self, action: #selector(self.tapGenre(_:)), for: .touchUpInside)
        headerView.addSubview(btnShowListGenre)
        let lblListGenre = UIButton(frame: CGRect(x: 10, y: 55, width:
            tableView.bounds.size.width, height: Constant.btnShowListGenre / 2))
        lblListGenre.setTitle("The most played tracks on SoundCloud this week", for: .normal)
        lblListGenre.titleLabel?.font = UIFont.boldSystemFont(ofSize: sizeFont / 2.5)
        lblListGenre.setTitleColor(.gray, for: .normal)
        lblListGenre.contentHorizontalAlignment = .left
        headerView.addSubview(lblListGenre)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  Constant.heightForHeaderInSection
    }
}

extension HomeViewController: ProtocolCellGene {
    private func configTableViewCell() {
        let nibName = UINib(nibName: "CellGenesHome", bundle: nil)
        self.homeTableView.register(nibName, forCellReuseIdentifier: "CellGenesHome")
    }
    
    private func configNaviBar() {
        self.navigationController?.navigationBar.topItem?.title = " SoundCloud "
        self.navigationController?.navigationBar.tintColor = .orange
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    
    @objc func tapGenre(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Genre", bundle: nil)
        guard let genreView = storyboard.instantiateViewController(withIdentifier:
            "GenreList") as? GenreViewController else {
                return
        }
        self.navigationController?.pushViewController(genreView, animated: true)
        genreView.nameGrenre = arrayAllGenre[sender.tag]
    }
    
    func didSelectItemAtCellGrense(dataSong: DataTrack, arrDataSongs: [DataTrack]) {
        let playViewController = PlayViewController(nibName: "PlayViewController", bundle: nil)
        self.present(playViewController, animated: false, completion: nil)
        playViewController.setUIPlay(dataTrack: dataSong, arrDataSongs: arrDataSongs)
    }
}
