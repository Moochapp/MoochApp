////
//  SubcategoryViewController.swift
//  Mooch
//
//  Created by App Center on 3/27/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit

class SubcategoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = category
        setupTable()
        
    }
    
    // MARK: - Properties
    var coordinator: MainCoordinator!
    var category: String!
    lazy var subcategories: [String] = {
        guard let category = self.category else {
            fatalError("SubcategoryViewController must have a category to load")
        }
        guard let subcategories = ExploreViewModel.categoryData.data[category] else {
            fatalError("An array must be returned from the the category data object to initialize the page")
        }
        
        var sorted = subcategories.sorted()
        
        return sorted
    }()
    var collectionViewDataSources: [String: SubcategoryCollectionViewDelegate] = [:]
    var dataSourceForCollectionViews: [String: [Item]] = [:]
    
    // MARK: - Outlets
    var tableView: UITableView = {
        let tbl = UITableView(frame: .zero, style: .plain)
        tbl.backgroundColor = #colorLiteral(red: 0.3623537421, green: 0.3584933877, blue: 0.3582365513, alpha: 1)
        tbl.separatorStyle = .none
        return tbl
    }()
    
    // MARK: - Actions
    @objc func shouldUpdateFilter(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }
    
    // MARK: - Setup
    
    func downloadItems(test: String, completion: ([Item])->()) {
        // Item.getResults(for: self.category) { (results) in {
        //                                        results = ["subcategory": [Item]]
        //     self.dataSourceForCollectionViews = results
        // }
//        #error("Start planning the item Implimentation phase") 
    }
    func setupTable() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        // Set Delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register cells
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "filterCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCell")
    }
    func setupCollectionView(cv: UICollectionView) {
        
    }
    
    // MARK: - Class Functions
    private func configureSegmentedControl() -> UISegmentedControl {
        let items = ["Mooch", "Rent", "Buy", "All"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.tintColor = EKColor.Mooch.lightBlue
        segmentedControl.addTarget(self, action: #selector(shouldUpdateFilter(sender:)), for: .valueChanged)
        return segmentedControl
    }
    
}

extension SubcategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.subcategories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath)
            cell.backgroundColor = .clear
            
            var segmentedControl: UISegmentedControl
            if let view = cell.viewWithTag(111) as? UISegmentedControl {
                segmentedControl = view
            } else {
                // Segmented Control
                segmentedControl = configureSegmentedControl()
                cell.addSubview(segmentedControl)
                segmentedControl.snp.makeConstraints { (make) in
                    make.left.right.bottom.top.equalToSuperview().inset(8)
                }
                segmentedControl.selectedSegmentIndex = 3
                segmentedControl.tag = 111
            }
            
            return cell
        } else {
            let title = self.subcategories[indexPath.row]
            let tag = Int("12\(indexPath.row + 1)")!
            
            var cell: UITableViewCell
            if let c = tableView.viewWithTag(tag) as? UITableViewCell {
                cell = c
                return cell
            } else {
                // CollectionView Setup
                cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
                cell.backgroundColor = .clear
                cell.tag = tag
                
                let flow = UICollectionViewFlowLayout()
                flow.scrollDirection = .horizontal
                
                let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flow)
                collectionView.backgroundColor = .clear
                cell.addSubview(collectionView)
                collectionView.snp.makeConstraints { (make) in
                    make.left.right.top.bottom.equalToSuperview().inset(8)
                }
                let random = Int.random(in: 0...11)
                let img = ExploreViewModel.categoryData.demoImages[random]
                let delegate = SubcategoryCollectionViewDelegate(subcategory: title, subcategoryImage: img,
                                                                 items: ["testing", "testing", "testing 234"])
                collectionViewDataSources[title] = delegate
                
                collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "subcategoryCell")
                collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "itemCell")
                collectionView.delegate = delegate
                collectionView.dataSource = delegate
                collectionView.reloadData()
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        } else {
            let numberPerRow = 3.5
            let spacing = 8.0
            let w = tableView.frame.width - 16
            let width = (Double(w) - (numberPerRow - 1) * spacing) / numberPerRow
            return CGFloat(width + 16)
        }
    }
    
}

class SubcategoryCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    init(subcategory: String, subcategoryImage: UIImage, items: [String]) {
        self.subcategory = subcategory
        self.subcategoryImage = subcategoryImage
        self.items = items
        super.init()
    }
    
    let subcategory: String
    let subcategoryImage: UIImage
    let items: [String]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subcategoryCell", for: indexPath)
            let bgImg = UIImageView(image: subcategoryImage)
            bgImg.contentMode = .scaleAspectFill
            bgImg.clipsToBounds = true
            bgImg.layer.cornerRadius = 5
            
            let label = UILabel()
            label.text = subcategory
            label.textColor = .white
            
            cell.addSubview(bgImg)
            bgImg.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            
            cell.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.bottom.right.equalToSuperview().inset(8)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath)
            let bgImg = UIImageView(image: subcategoryImage)
            bgImg.contentMode = .scaleAspectFill
            bgImg.clipsToBounds = true
            bgImg.layer.cornerRadius = 5
            
            cell.addSubview(bgImg)
            bgImg.snp.makeConstraints { (make) in
                make.left.right.top.bottom.equalToSuperview()
            }
            
            let profileImage = UIImageView(image: subcategoryImage)
            profileImage.contentMode = .scaleAspectFill
            profileImage.clipsToBounds = true
            profileImage.layer.cornerRadius = profileImage.frame.height / 2
            
            cell.addSubview(profileImage)
            profileImage.snp.makeConstraints { (make) in
                make.left.bottom.equalToSuperview().inset(8)
                make.height.width.equalTo(20)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            let numberPerRow = 3.5
            let spacing = 8.0
            let width = Double(collectionView.frame.width)
            let height = (width - (numberPerRow - 1) * spacing) / numberPerRow
            return CGSize(width: width / 2 , height: height)
        } else {
            let numberPerRow = 3.5
            let spacing = 8.0
            let width = (Double(collectionView.frame.width) - (numberPerRow - 1) * spacing) / numberPerRow
            return CGSize(width: width, height: width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}
