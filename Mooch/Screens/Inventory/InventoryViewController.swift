////
//  InventoryViewController.swift
//  Mooch
//
//  Created by App Center on 3/19/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit

class InventoryViewController: UIViewController {

    var coordinator: MainCoordinator!
    var tableView: UITableView!
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTableView()
        
    }
    
    func setupView() {
        self.view.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        coordinator.navigationController.isNavigationBarHidden = false
        title = "Inventory"
    }
    
    func setupTableView() {
        self.tableView = UITableView(frame: .zero, style: .plain)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "topCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "bottomCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = .clear
        self.view.addSubview(tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

extension InventoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return tableView.frame.height
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topCell", for: indexPath)
            
            let button = UIButton(type: .system)
            button.setTitle("Add Item", for: .normal)
            cell.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.centerX.bottom.equalToSuperview()
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bottomCell", for: indexPath)
            
            cell.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            // Create colelctionview, set delegates, register cells
            let collectionView = createCollectionView()
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ItemCell")
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.isScrollEnabled = false
            
            cell.addSubview(collectionView)
            // Add to subview and make constraints
            collectionView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview().inset(8)
            }
            cell.layoutIfNeeded()
            
            return cell
        }
    }
    
    func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        
        return collectionView
    }
    
}

extension InventoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath)
        
        cell.backgroundColor = .red
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cWidth = collectionView.frame.width
        let numberPerRow = CGFloat(3.0)
        let spacing = CGFloat(8.0)
        let width = (cWidth - (numberPerRow * spacing)) / numberPerRow
        
        return CGSize(width: width, height: width)
    }
    
}
