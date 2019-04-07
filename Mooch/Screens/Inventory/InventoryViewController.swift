////
//  InventoryViewController.swift
//  Mooch
//
//  Created by App Center on 3/19/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit

class InventoryViewController: UIViewController, Storyboarded {

    var coordinator: MainCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Inventory"
        
        setupView()
        setupCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        coordinator.navigationController.isNavigationBarHidden = true
    }
    
    private func setupView() {
        self.view.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem(sender:)))
        self.navigationItem.rightBarButtonItem = add
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.01112855412, green: 0.7845740914, blue: 0.9864193797, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        
        // Create colelctionview, set delegates, register cells
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ItemCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.view.addSubview(collectionView)
        // Add to subview and make constraints
        collectionView.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview().inset(8)
//            make.top.bottom.equalToSuperview().inset(16)
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges).inset(8)
        }
        
    }
    
    private func getInventoryData() {
        
    }
    
    @objc func addItem(sender: UIBarButtonItem) {
        coordinator.chooseCreateMethod()
    }
}

extension InventoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 19
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath)
        
        cell.backgroundColor = .lightGray
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
}
