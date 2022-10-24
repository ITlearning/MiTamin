//
//  AddWishListViewController.swift
//  iTamin
//
//  Created by Tabber on 2022/10/25.
//

import UIKit

class AddWishListViewController: UIViewController {

    
    let tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationConfigure(title: "마이데이")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }
    

    func configureTableView() {
        
    }

}
