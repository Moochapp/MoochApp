////
//  ExploreViewController.swift
//  Mooch
//
//  Created by App Center on 3/1/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit
import SnapKit

class ExploreViewController: UIViewController, Storyboarded {

    // MARK: - Properties
    var coordinator: MainCoordinator!
    var viewModel: ExploreViewModel!
    
    // MARK: - Outlets
    var tableView: UITableView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Explore"
        self.view.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        viewModel = ExploreViewModel(viewController: self)
        viewModel.setDelegatesForDataObjectManagers()
        self.tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "featuredCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "favoritesCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoriesCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        coordinator.navigationController.isNavigationBarHidden = true
    }
    
    
}

extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 3
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "featuredCell", for: indexPath)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
            var collectionView: UICollectionView
            if let cv = view.viewWithTag(1) as? UICollectionView {
                collectionView = cv
            } else {
                collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
                cell.addSubview(collectionView)
                collectionView.tag = 1
                collectionView.backgroundColor = .clear
                if let layout = collectionView.collectionViewLayout as?  UICollectionViewFlowLayout {
                    layout.scrollDirection = .horizontal
                }
                collectionView.register(FeaturedCollectionViewCell.self, forCellWithReuseIdentifier: "featuredCell")
                collectionView.dataSource = viewModel.featuredData
                collectionView.delegate = viewModel.featuredData
                collectionView.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
                }
                cell.sizeToFit()
            }
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
            var image: UIImageView
            if let img = view.viewWithTag(11) as? UIImageView {
                image = img
            } else {
                image = UIImageView(image: viewModel.images[indexPath.row])
                image.tag = 11
                cell.addSubview(image)
                image.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
                    make.height.equalTo(150)
                }
                image.contentMode = .scaleAspectFill
                image.layer.cornerRadius = 5
                image.clipsToBounds = true
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell", for: indexPath)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            
            var collectionView: UICollectionView
            if let cv = view.viewWithTag(21) as? UICollectionView {
                collectionView = cv
            } else {
                let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
                collectionView.tag = 21
                cell.addSubview(collectionView)
                
                collectionView.backgroundColor = .clear
                collectionView.snp.makeConstraints { (make) in
                    make.top.bottom.equalToSuperview().inset(8)
                    make.left.right.equalToSuperview().inset(8)
                }
                collectionView.isScrollEnabled = false
                collectionView.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: "categoriesCell")
                
                collectionView.dataSource = viewModel.categoryData
                collectionView.delegate = viewModel.categoryData
            }

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 100.0
        } else if indexPath.section == 1 {
            return 150
        } else {
            let width = ((Double(tableView.frame.width) - 16) - (2) * 8) / 3
            let height = (width * 6) + (6 * 8)
            return CGFloat(height)
        }
    }
    
}


class FeaturedDataObject: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    init(images: [UIImage]) {
        self.images = images
    }
    
    var delegate: ExploreDataObjectDelegate?
    var images: [UIImage]
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = images.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featuredCell", for: indexPath)
        
        let image = UIImageView(image: images[indexPath.row])
        cell.addSubview(image)
        image.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
    }
    
}

class FavoritesDataObject: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    init(images: [UIImage]) {
        self.images = images
    }
    
    var images: [UIImage]
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoritesCell", for: indexPath)
        
        cell.backgroundColor = .blue
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 150)
        
    }
}

class CategoriesDataObject: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    init(titles: [String], images: [UIImage]) {
        self.images = images
        self.titles = titles
    }
    
    var delegate: ExploreDataObjectDelegate?
    var images: [UIImage]
    var titles: [String]
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCell", for: indexPath)
        
        let image = UIImageView(image: images[indexPath.row])
        cell.addSubview(image)
        image.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        
        let label = UILabel(frame: .zero)
        label.text = titles[indexPath.row]
        label.font = UIFont(name: "AvenirNext", size: 10)
        label.textColor = .white
        cell.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberPerRow = 3.0
        let spacing = 8.0
        let width = (Double(collectionView.frame.width) - (numberPerRow - 1) * spacing) / numberPerRow
        
        return CGSize(width: width, height: width)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let category = titles[indexPath.row]
        let image = images[indexPath.row]
        delegate?.didSelectItem(category: category, image: image)
    }
}

protocol ExploreDataObjectDelegate {
    func didSelectItem(category: String, image: UIImage)
}
