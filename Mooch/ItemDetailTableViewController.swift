////
//  ItemDetailTableViewController.swift
//  Mooch
//
//  Created by App Center on 4/9/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit
import LDLogger

class ItemDetailTableViewController: UITableViewController {

    var coordinator: MainCoordinator!
    var item: Item!
    
    // MARK: - ViewModel
    var IDImageCollectionView: UICollectionView!
    var IDImageCollectionViewDelegate: ItemDetailImageCollectionViewDelegate!
    
    var IDRelatedCollectionView: UICollectionView!
    var IDRelatedCollectionViewDelegate: ItemDetailRelatedCollectionViewDelegate!
    
    var IDOwnerItemsCollectionView: UICollectionView!
    var IDOwnerItemsCollectionViewDelegate: ItemDetailOwnerItemsCollectionViewDelegate!
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        createCollections()
        createCollectionDelegates()
      
    }
    
    // MARK: - Setup
    private func setupTableView() {
        for i in 0...3 {
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell-\(i)")
        }
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    private func createCollections() {
        let layout1 = SnappingCollectionViewLayout()
        layout1.scrollDirection = .horizontal
        IDImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout1)
        IDImageCollectionView.decelerationRate = .fast
        IDImageCollectionView.backgroundColor = .clear
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        IDRelatedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout2)
        IDRelatedCollectionView.decelerationRate = .fast
        IDRelatedCollectionView.backgroundColor = .clear
        
        let layout3 = UICollectionViewFlowLayout()
        layout3.scrollDirection = .vertical
        IDOwnerItemsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout3)
        IDOwnerItemsCollectionView.decelerationRate = .fast
        IDOwnerItemsCollectionView.backgroundColor = .clear
    }
    private func createCollectionDelegates() {
        IDImageCollectionViewDelegate = ItemDetailImageCollectionViewDelegate(images: item.images, collectionView: IDImageCollectionView)
        IDImageCollectionView.delegate = IDImageCollectionViewDelegate
        IDImageCollectionView.dataSource = IDImageCollectionViewDelegate
        
        IDRelatedCollectionViewDelegate = ItemDetailRelatedCollectionViewDelegate(items: [], collectionView: IDRelatedCollectionView)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            FirebaseManager.items.whereField("Category", isEqualTo: self?.item.category).order(by: "Timestamp", descending: true).limit(to: 10).getDocuments { (snapshot, error) in
                guard error == nil else {
                    Log.e(error!.localizedDescription)
                    return
                }
                guard let snap = snapshot else {
                    Log.e("Couldn't get snapshot")
                    return
                }
                
                var related: [Item] = []
                for doc in snap.documents {
                    related.append(Item(document: doc))
                }
                
                DispatchQueue.main.async {
                    self?.IDRelatedCollectionView.delegate = self?.IDRelatedCollectionViewDelegate
                    self?.IDRelatedCollectionView.dataSource = self?.IDRelatedCollectionViewDelegate
                    self?.IDRelatedCollectionView.reloadData()
                }
            }
        }
        
        IDOwnerItemsCollectionViewDelegate = ItemDetailOwnerItemsCollectionViewDelegate(items: [], collectionView: IDOwnerItemsCollectionView)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            FirebaseManager.items.whereField("Owner", isEqualTo: self?.item.owner).order(by: "Timestamp", descending: true).limit(to: 12).getDocuments(completion: { (snapshot, error) in
                guard error == nil else {
                    Log.e(error!.localizedDescription)
                    return
                }
                guard let snap = snapshot else {
                    Log.e("Couldn't get snapshot")
                    return
                }
                
                var related: [Item] = []
                for doc in snap.documents {
                    related.append(Item(document: doc))
                }
                
                DispatchQueue.main.async {
                    self?.IDOwnerItemsCollectionView.delegate = self?.IDOwnerItemsCollectionViewDelegate
                    self?.IDOwnerItemsCollectionView.dataSource = self?.IDOwnerItemsCollectionViewDelegate
                    self?.IDOwnerItemsCollectionView.reloadData()
                }
            })
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "cell-\(indexPath.section)"
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
            
            cell.addSubview(IDImageCollectionView)
            IDImageCollectionView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
                cell.sizeToFit()
            }
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
            cell.backgroundColor = EKColor.Mooch.darkGray
            
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
            cell.backgroundColor = EKColor.Mooch.darkGray
            
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
            cell.backgroundColor = EKColor.Mooch.darkGray
            
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.backgroundColor = EKColor.Mooch.darkGray
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 200
        case 1:
            return 150
        case 2:
            return 100
        case 3:
            return 250
        default:
            return 0
        }
    }
}

class ItemDetailImageCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    static var identifier = "IDImageCVCell"
    
    var images: [UIImage]
    
    init(images: [UIImage], collectionView: UICollectionView) {
        self.images = images
        Log.d(ItemDetailImageCollectionViewDelegate.identifier, images.count)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ItemDetailImageCollectionViewDelegate.identifier)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemDetailImageCollectionViewDelegate.identifier, for: indexPath)
        
        let imageView = UIImageView(image: images[indexPath.row])
        imageView.contentMode = .scaleAspectFill
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Log.d(indexPath.row)
    }
}

class ItemDetailRelatedCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    static var identifier = "IDRelatedCVCell"
    
    var relatedItems: [Item]
    
    init(items: [Item], collectionView: UICollectionView) {
        self.relatedItems = items
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ItemDetailRelatedCollectionViewDelegate.identifier)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemDetailRelatedCollectionViewDelegate.identifier, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let space = 8.0
        let itemPerRow = 5.5
        
        let size = (Double(width) - (space * itemPerRow)) / itemPerRow
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Log.d(indexPath.row)
    }
}

class ItemDetailOwnerItemsCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    static var identifier = "IDOwnerItemsCVCell"
    
    var ownerItems: [Item]
    
    init(items: [Item], collectionView: UICollectionView) {
        self.ownerItems = items
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ItemDetailOwnerItemsCollectionViewDelegate.identifier)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ownerItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemDetailOwnerItemsCollectionViewDelegate.identifier, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let space = 8.0
        let itemPerRow = 3.0
        
        let size = (Double(width) - (space * itemPerRow)) / itemPerRow
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Log.d(indexPath.row)
    }
}


