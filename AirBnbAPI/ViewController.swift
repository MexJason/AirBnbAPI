//
//  ViewController.swift
//  AirBnbAPI
//
//  Created by YouTube on 10/22/22.
//

import UIKit

class ViewController: UIViewController {

    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            try? await APIService.shared.fetchListingsFor()
        }
    }


}

