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

    override func viewDidLoad() {
        super.viewDidLoad()
        arrayAllGenre = [ Genre.danceEdm, Genre.pop, Genre.rbSoul, Genre.rock, Genre.country ]
        DataManager.sharedInstance.getDataID(arrayGenre: arrayAllGenre,
                                             quantity: 5) {[weak self] (data) in
                                                guard let arrData = data else {
                                                    return
                                                }
                                                self?.dataTrack = arrData
                                                DispatchQueue.main.async {
                                                    self?.homeTableView.reloadData()
                                                }
        }
    }
}
