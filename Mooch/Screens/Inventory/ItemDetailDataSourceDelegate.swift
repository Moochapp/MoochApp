////
//  ItemDetailDataSourceDelegate.swift
//  Mooch
//
//  Created by App Center on 3/31/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import UIKit

protocol ItemDetailDataSourceDelegate {
    func didSelectProfileImage()
}

class ItemDetailTableViewDataSource: NSObject, UITableViewDataSource {
    
    var item: Item
    var sectionNames = ["sectionOne", "sectionTwo", "sectionThree", "sectionFour"]
    var delegate: ItemDetailDataSourceDelegate?
    
    var imageCollectionDelegate: ItemImagesCollectionViewDelegate!
    
    init(tableView: UITableView, item: Item) {
        self.item = item
        self.imageCollectionDelegate = ItemImagesCollectionViewDelegate(item: item)
        for item in sectionNames {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: item)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            return createSectionOne(tableView: tableView, indexPath: indexPath)
        } else if section == 1 {
            return createSectionTwo(tableView: tableView, indexPath: indexPath)
        } else if section == 2 {
            return createSectionThree(tableView: tableView, indexPath: indexPath)
        } else {
            return createSectionFour(tableView: tableView, indexPath: indexPath)
        }
    }
    
    private func createSectionOne(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionOne", for: indexPath)
        cell.backgroundColor = .clear
        
        var collectionView: UICollectionView
        if let view = tableView.viewWithTag(11) as? UICollectionView {
            collectionView = view
        } else {
            let layout = SnappingCollectionViewLayout()
            layout.scrollDirection = .horizontal
            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ItemImage")
            collectionView.decelerationRate = .fast
            collectionView.backgroundColor = .clear
            collectionView.tag = 11
            cell.addSubview(collectionView)
            collectionView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        
        var profilePicture: ProfilePicture
        if let view = tableView.viewWithTag(12) as? ProfilePicture {
            profilePicture = view
        } else {
            profilePicture = ProfilePicture(frame: .zero)
            // profilePicture.image = Moocher.profilePictureFor(id: item.owner)
            // This should be async. After downloading image, the image should be cached.
            // profilePicture.cacheImage(for: owner)
            profilePicture.delegate = self
            profilePicture.tag = 12
            profilePicture.image.contentMode = .scaleAspectFill
            cell.addSubview(profilePicture)
            profilePicture.snp.makeConstraints { (make) in
                make.bottom.left.equalToSuperview().inset(16)
                make.height.width.equalTo(36)
            }
        }
        
        var moochItButton: UIButton
        if let view = tableView.viewWithTag(13) as? UIButton {
            moochItButton = view
        } else {
            moochItButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 36))
            moochItButton.layer.cornerRadius = 18
            moochItButton.backgroundColor = EKColor.Mooch.lightBlue
            moochItButton.setTitleColor(.white, for: .normal)
            moochItButton.tag = 13
            moochItButton.snp.makeConstraints { (make) in
                make.right.bottom.equalToSuperview().inset(16)
            }
        }
        
        return cell
    }
    
    private func createSectionTwo(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionTwo", for: indexPath)
        
        return cell
    }
    
    private func createSectionThree(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionThree", for: indexPath)
        
        return cell
    }
    
    private func createSectionFour(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionFour", for: indexPath)
        
        return cell
    }
    
}

class ItemImagesCollectionViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var item: Item
    
    init(item: Item) {
        self.item = item
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        
        let image = UIImageView(image: item.images[indexPath.row])
        cell.addSubview(image)
        image.snp
        
        return cell
    }
    
}

extension ItemDetailTableViewDataSource: ProfilePictureDelegate {
    func didSelectProfilePicture() {
        delegate?.didSelectProfileImage()
    }
    
}
