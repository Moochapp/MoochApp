////
//  ItemDetailViewController.swift
//  Mooch
//
//  Created by App Center on 3/27/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {

    var coordinator: MainCoordinator!
    var item: Item!
    
    var tableView: UITableView!
    var tableViewDataSource: ItemDetailTableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        
        createTableView()
        createTableViewDataSource()
        
    }
    
    func createTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func createTableViewDataSource() {
        tableViewDataSource = ItemDetailTableViewDataSource(tableView: self.tableView, item: self.item)
        tableViewDataSource.delegate = self
        tableView.dataSource = tableViewDataSource
    }
    
}

extension ItemDetailViewController: UITableViewDelegate {
    
}

extension ItemDetailViewController: ItemDetailDataSourceDelegate {
    func didSelectProfileImage() {
        print("Selected Profile Picture")
    }
}
