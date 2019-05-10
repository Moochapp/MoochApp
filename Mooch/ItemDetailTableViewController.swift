////
//  ItemDetailTableViewController.swift
//  Mooch
//
//  Created by App Center on 4/9/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit
import LDLogger
import DZNEmptyDataSet

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

        title = item.name
        self.view.backgroundColor = EKColor.Mooch.darkGray
        setupTableView()
        createCollections()
        createCollectionDelegates()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - Setup
    private func setupTableView() {
        tableView.separatorStyle = .none
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
        var orderedImages: [UIImage] = []
        for i in 0...item.numberOfImages - 1 {
            let name = "img-\(i)"
            do {
                let img = try Session.shared.cache.getImageFrom(itemID: item.id, imageID: name)
                orderedImages.append(img)
            } catch {
                Log.e(error)
            }
        }
        item.images = orderedImages
        // Images
        IDImageCollectionViewDelegate = ItemDetailImageCollectionViewDelegate(images: item.images, collectionView: IDImageCollectionView)
        IDImageCollectionView.delegate = IDImageCollectionViewDelegate
        IDImageCollectionView.dataSource = IDImageCollectionViewDelegate
        
        
        // Related
        IDRelatedCollectionViewDelegate = ItemDetailRelatedCollectionViewDelegate(items: [], collectionView: IDRelatedCollectionView, coordinator: self.coordinator)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            FirebaseManager.items
                .whereField("Category", isEqualTo: self?.item.category)
                .order(by: "Timestamp", descending: true).limit(to: 10).getDocuments { (snapshot, error) in
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
                    let newItem = Item(document: doc)
                    if newItem.id != self?.item.id {
                        related.append(newItem)
                    } else {
                        Log.d("Skipping duplicate item.")
                    }
                }
                
                self?.IDRelatedCollectionViewDelegate.relatedItems = related
                    
                DispatchQueue.main.async {
                    self?.IDRelatedCollectionView.delegate = self?.IDRelatedCollectionViewDelegate
                    self?.IDRelatedCollectionView.dataSource = self?.IDRelatedCollectionViewDelegate
                    self?.IDRelatedCollectionView.reloadData()
                }
            }
        }
        IDRelatedCollectionView.emptyDataSetSource = IDRelatedCollectionViewDelegate
        IDRelatedCollectionView.emptyDataSetDelegate = IDRelatedCollectionViewDelegate
        
        // Owner
        IDOwnerItemsCollectionViewDelegate = ItemDetailOwnerItemsCollectionViewDelegate(items: [], collectionView: IDOwnerItemsCollectionView, coordinator: self.coordinator)
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
                    let newItem = Item(document: doc)
                    if newItem.id != self?.item.id {
                        related.append(newItem)
                    } else {
                        Log.d("Skipping duplicate item")
                    }
                }
                
                self?.IDOwnerItemsCollectionViewDelegate.ownerItems = related
                
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
            // IMAGES
            let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
            cell.backgroundColor = EKColor.Mooch.darkGray
            cell.selectionStyle = .none
            
            cell.addSubview(IDImageCollectionView)
            IDImageCollectionView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
                cell.sizeToFit()
            }
            
            return cell
        case 1:
            // DETAILS
            let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
            cell.backgroundColor = EKColor.Mooch.darkGray
            cell.selectionStyle = .none
            
            let contentView = ItemDetailsView(item: self.item, frame: CGRect(x: 16, y: 16, width: cell.frame.width, height: cell.frame.height))
            cell.addSubview(contentView)
            contentView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview().inset(16)
                cell.sizeToFit()
            }
            
            return cell
        case 2:
            // RELATED
            let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
            cell.backgroundColor = EKColor.Mooch.darkGray
            cell.selectionStyle = .none
            
            let label = UILabel(frame: .zero)
            label.textColor = UIColor.lightGray
            label.text = "More like this"
            
            cell.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(8)
                make.left.right.equalToSuperview().inset(16)
            }
            
            cell.addSubview(IDRelatedCollectionView)
            IDRelatedCollectionView.snp.makeConstraints { (make) in
                make.top.equalTo(label.snp.bottom).offset(8)
                make.left.right.bottom.equalToSuperview().inset(16)
                cell.sizeToFit()
            }
            
            return cell
        case 3:
            // OWNER
            let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
            cell.backgroundColor = EKColor.Mooch.darkGray
            cell.selectionStyle = .none
            
            let label = UILabel(frame: .zero)
            label.textColor = UIColor.lightGray
            Moocher.nameFrom(id: item.owner) { (name) in
                if let name = name {
                    DispatchQueue.main.async {
                        label.text = "More by \(name)"
                    }
                } else {
                    DispatchQueue.main.async {
                        label.text = "More by owner"
                    }
                }
        
            }
            
            cell.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(8)
                make.left.right.equalToSuperview().inset(16)
            }
            
            cell.addSubview(IDOwnerItemsCollectionView)
            IDOwnerItemsCollectionView.isScrollEnabled = false
            IDOwnerItemsCollectionView.snp.makeConstraints { (make) in
                make.top.equalTo(label.snp.bottom).offset(8)
                make.left.right.bottom.equalToSuperview().inset(16)
                cell.sizeToFit()
            }
            
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.backgroundColor = EKColor.Mooch.darkGray
            cell.selectionStyle = .none
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 250
        case 1:
            return 200
        case 2:
            return 150
        case 3:
            return 300
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

class ItemDetailRelatedCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    static var identifier = "IDRelatedCVCell"
    
    var relatedItems: [Item]
    var coordinator: MainCoordinator
    
    init(items: [Item], collectionView: UICollectionView, coordinator: MainCoordinator) {
        self.relatedItems = items
        self.coordinator = coordinator
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ItemDetailRelatedCollectionViewDelegate.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relatedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemDetailRelatedCollectionViewDelegate.identifier, for: indexPath)
        
        
        let item = relatedItems[indexPath.row]
        
        cell.backgroundColor = .lightGray
        cell.layer.cornerRadius = 5
        
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 5
        imgView.clipsToBounds = true
        cell.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        do {
            let img = try Session.shared.cache.getImageFrom(itemID: item.id, imageID: "img-0")
            DispatchQueue.main.async {
                imgView.image = img
            }
        } catch {
            Log.e(error)
            item.downloadImages(completion: { (done) in
                Log.d("Finished loading images")
            }) { (thumbnail) in
                do {
                    let img = try Session.shared.cache.getImageFrom(itemID: item.id, imageID: "img-0")
                    DispatchQueue.main.async {
                        imgView.image = img
                    }
                } catch {
                    Log.e(error)
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let space = 8.0
        let itemPerRow = 4.5
        
        let size = (Double(width) - (space * itemPerRow)) / itemPerRow
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = relatedItems[indexPath.row]
        coordinator.showItemDetail(for: item)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = "Nothing to see here... yet!"
        let attr = NSAttributedString(string: title)
        return attr
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = "When you and you friends add more items to this category, you'll see those items appear here!"
        let attr = NSAttributedString(string: title)
        return attr
    }
}

class ItemDetailOwnerItemsCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    static var identifier = "IDOwnerItemsCVCell"
    
    var ownerItems: [Item]
    var coordinator: MainCoordinator
    
    init(items: [Item], collectionView: UICollectionView, coordinator: MainCoordinator) {
        self.ownerItems = items
        self.coordinator = coordinator
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ItemDetailOwnerItemsCollectionViewDelegate.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ownerItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemDetailOwnerItemsCollectionViewDelegate.identifier, for: indexPath)
        
        let item = ownerItems[indexPath.row]
        
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 5
        imgView.clipsToBounds = true
        cell.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        do {
            let img = try Session.shared.cache.getImageFrom(itemID: item.id, imageID: "img-0")
            DispatchQueue.main.async {
                imgView.image = img
            }
        } catch {
            Log.e(error)
            item.downloadImages(completion: { (done) in
                Log.d("Finished loading images")
            }) { (thumbnail) in
                do {
                    let img = try Session.shared.cache.getImageFrom(itemID: item.id, imageID: "img-0")
                    DispatchQueue.main.async {
                        imgView.image = img
                    }
                } catch {
                    Log.e(error)
                }
            }
        }
        
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
        let item = ownerItems[indexPath.row]
        coordinator.showItemDetail(for: item)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = "Nothing to see here... yet!"
        let attr = NSAttributedString(string: title)
        return attr
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = "When your friend add more items, you'll see those items appear here!"
        let attr = NSAttributedString(string: title)
        return attr
    }
}


