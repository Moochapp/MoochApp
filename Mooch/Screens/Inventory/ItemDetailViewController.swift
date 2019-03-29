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
    let cellDescriptions = ["ImageAreaSectionCell", "DetailsSectionCell", "SimilarItemsCell", "MoreItemsCell"]
    var dataSource: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        setupTable()
        setupCollectionViews()
        
    }
    
    var tableView: UITableView!
    var imageGallaryCollectionView: UICollectionView?
    var moreItemsCollectionView: UICollectionView!
    var moreByOwnerCollectionView: UICollectionView!

    func setupTable() {
        self.tableView = UITableView(frame: .zero, style: .plain)
        self.view.addSubview(tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(8)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(16)
        }
        for item in cellDescriptions {
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: item)
        }
        self.tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 20
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
    func setupCollectionViews() {
        moreItemsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        moreItemsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "SimilarItem")
        moreItemsCollectionView.backgroundColor = .clear
        
        moreByOwnerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        moreByOwnerCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "OwnerItem")
        moreByOwnerCollectionView.backgroundColor = .clear
    }
    
    @objc func changeContentMode(sender: UITapGestureRecognizer) {
        if let view = sender.view {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: {
                    if view.contentMode == .scaleAspectFill {
                        view.contentMode = .scaleAspectFit
                    } else {
                        view.contentMode = .scaleAspectFill
                    }
                })
            }
        }
    }
    
}

extension ItemDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        } else if indexPath.row == 1 {
            return 130
        } else if indexPath.row == 2 {
            return 120
        } else if indexPath.row == 3 {
            return 200
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            // Configure cell 1
            let cell = tableView.dequeueReusableCell(withIdentifier: cellDescriptions[indexPath.row], for: indexPath)
            
            if self.item.images.count > 1 {
                let layout = SnappingCollectionViewLayout()
                layout.scrollDirection = .horizontal
                imageGallaryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
                imageGallaryCollectionView?.backgroundColor = .clear
                imageGallaryCollectionView?.decelerationRate = .fast
                imageGallaryCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ItemImage")
                imageGallaryCollectionView?.delegate = self
                imageGallaryCollectionView?.dataSource = self
                
                cell.addSubview(imageGallaryCollectionView!)
                
                imageGallaryCollectionView!.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
                
            } else {
                guard let image = self.item.images.first else {
                    return cell
                }
                
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                
                cell.addSubview(imageView)
                
                imageView.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
                
            }
            
            return cell
        } else if section == 1 {
            // Configure cell 2
            let cell = tableView.dequeueReusableCell(withIdentifier: cellDescriptions[indexPath.row], for: indexPath)
            
            return cell
        } else if section == 2 {
            // Configure cell 3
            let cell = tableView.dequeueReusableCell(withIdentifier: cellDescriptions[indexPath.row], for: indexPath)
            
            return cell
        } else {
            // Configure cell 4
            let cell = tableView.dequeueReusableCell(withIdentifier: cellDescriptions[indexPath.row], for: indexPath)
            
            return cell
        }
    }
    
}

extension ItemDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == moreItemsCollectionView {
            return 2
        } else if collectionView == moreByOwnerCollectionView {
            return 2
        } else {
            return self.item.images.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == moreItemsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarItem", for: indexPath)
            
            cell.backgroundColor = .red
            
            return cell
        } else if collectionView == moreByOwnerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OwnerItem", for: indexPath)
            
            cell.backgroundColor = .blue
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemImage", for: indexPath)
            
            cell.backgroundColor = .orange
            let imageView = UIImageView(image: self.item.images[indexPath.row])
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(changeContentMode(sender:)))
            tap.numberOfTapsRequired = 2
            
            imageView.addGestureRecognizer(tap)
            
            cell.addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == moreItemsCollectionView {
            return CGSize(width: 80, height: 80)
        } else if collectionView == moreByOwnerCollectionView {
            let cWidth = collectionView.frame.width
            let numberPerRow = CGFloat(3.0)
            let spacing = CGFloat(8.0)
            let width = (cWidth - (numberPerRow * spacing)) / numberPerRow
            
            return CGSize(width: width, height: width)
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == moreItemsCollectionView {
            return 8.0
        } else if collectionView == moreByOwnerCollectionView {
            return 8.0
        } else {
            return 8.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == moreItemsCollectionView {
            return 8.0
        } else if collectionView == moreByOwnerCollectionView {
            return 8.0
        } else {
            return 8.0
        }
    }
}
