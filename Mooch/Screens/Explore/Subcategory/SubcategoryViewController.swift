////
//  SubcategoryViewController.swift
//  Mooch
//
//  Created by App Center on 3/27/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit
import LDLogger

class SubcategoryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    public var coordinator: MainCoordinator!
    public var category: String!
    public var subcategories: [String]!
    public var itemsForSubcategories: [String: [Item]]?
    
    private let topCellID = "topCell"
    private let mainCellID = "mainCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = category
        self.navigationController?.isNavigationBarHidden = false
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = EKColor.Mooch.darkGray
        collectionView.register(TopNavCVCell.self, forCellWithReuseIdentifier: topCellID)
        collectionView.register(MainCVCell.self, forCellWithReuseIdentifier: mainCellID)
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return itemsForSubcategories?.count ?? 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: topCellID, for: indexPath) as! TopNavCVCell
            cell.segmentDelegate = self
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainCellID, for: indexPath) as! MainCVCell
            cell.categoryName = self.category
            let subcategory = Array(itemsForSubcategories!.keys)[indexPath.row]
            guard let items = itemsForSubcategories?[subcategory] else { return cell }
            cell.subcategoryName = subcategory
            cell.itemsForSubcategory = items
            cell.itemDelegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: 75.0)
        } else {
            return CGSize(width: collectionView.frame.width, height: 120.0)
        }
    }
}

extension SubcategoryViewController: MoochSegmentedControlDelegate, CellItemDelegate {
    func didSelect(index: Int) {
        print("Selected: \(index)")
    }
    
    func didSelect(item: Item) {
        coordinator.showItemDetail(for: item)
    }
}

protocol MoochSegmentedControlDelegate {
    func didSelect(index: Int)
}

// Top and Main are the topmost Cells, effectively acting as sections
class TopNavCVCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var segmentDelegate: MoochSegmentedControlDelegate? = nil
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Mooch", "Buy", "Rent", "All"])
        control.addTarget(self, action: #selector(didSelectItem(control:)), for: .valueChanged)
        control.tintColor = EKColor.Mooch.lightBlue
        control.selectedSegmentIndex = 3
        return control
    }()
    
    func setupView() {
        backgroundColor = .clear
        addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(8)
            make.center.equalToSuperview()
        }
    }
    
    @objc private func didSelectItem(control: UISegmentedControl) {
        segmentDelegate?.didSelect(index: control.selectedSegmentIndex)
    }
}
class MainCVCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var categoryName: String!
    var subcategoryName: String!
    var itemsForSubcategory: [Item]!
    let itemsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
       
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = EKColor.Mooch.darkGray
        
        return collectionView
    }()
    var itemDelegate: CellItemDelegate?
    
    private let subcatCellID = "SubcategoryCellD"
    private let itemCellID = "ItemCellID"
    
    func setupView() {
        backgroundColor = EKColor.Mooch.darkGray
        addSubview(itemsCollectionView)
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        itemsCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(8)
        }
        itemsCollectionView.register(SubcategoryItemCollectionViewCell.self, forCellWithReuseIdentifier: subcatCellID)
        itemsCollectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: itemCellID)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsForSubcategory.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: subcatCellID, for: indexPath) as! SubcategoryItemCollectionViewCell
            
            cell.titleLabel.text = subcategoryName
            guard let img = StockImageLoader.shared.getImage(category: categoryName, subcategory: subcategoryName) else { return cell }
            cell.categoryImage.image = img
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellID, for: indexPath) as! ItemCollectionViewCell
            
            let item = itemsForSubcategory[indexPath.row - 1]
            cell.item = item
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.frame.width
        
        if indexPath.row == 0 {
            let width = w * (4/10)
            let height = CGFloat(100)
            
            return CGSize(width: width, height: height)
        } else {
            return CGSize(width: 100, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            Log.d("Selected \(subcategoryName!)")
        } else {
            Log.d("Selected \(itemsForSubcategory[indexPath.row - 1].name)")
            let item = itemsForSubcategory[indexPath.row - 1]
            itemDelegate?.didSelect(item: item)
        }
    }
}

// Subcat and Item Cells are use to separate the style of cell between the category image, and the items in that subcategory
class SubcategoryItemCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let categoryImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        
        return imageView
    }()
    let fadeView: UIView = {
        let fade = UIView()
        fade.clipsToBounds = true
        fade.layer.cornerRadius = 5
        fade.backgroundColor = EKColor.Mooch.darkGray
        fade.alpha = 0.25
        
        return fade
    }()
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "Avenir", size: 17)
        label.numberOfLines = 1
        label.textColor = .white
        
        return label
    }()
    
    func setupView() {
        backgroundColor = EKColor.Mooch.darkGray
        
        addSubview(categoryImage)
        addSubview(fadeView)
        addSubview(titleLabel)
        
        categoryImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        fadeView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(8)
        }
    }
}
class ItemCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var item: Item! {
        didSet {
            if item.checkForImagesInCache().count > 0 {
                DispatchQueue.main.async {
                    do {
                        let img = try Session.shared.cache.getImageFrom(itemID: self.item.id, imageID: "img-0")
                        self.itemImage.image = img
                    } catch {
                        Log.e(error)
                    }
                    
                    self.loading.stopAnimating()
                    self.removeBorder()
                }
            } else {
                item.downloadImages(completion: { (done) in
                    Log.d("Finished loading a set of data")
                }) { (thumbnail) in
                    DispatchQueue.main.async {
                        do {
                            let img = try Session.shared.cache.getImageFrom(itemID: self.item.id, imageID: "img-0")
                            self.itemImage.image = img
                        } catch {
                            Log.e(error)
                        }
                        
                        self.loading.stopAnimating()
                        self.removeBorder()
                    }
                }
            }
        }
    }
    
    let itemImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        
        return imageView
    }()
    let loading: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .white)
        
        return indicator
    }()
    
    func setupView() {
        backgroundColor = EKColor.Mooch.darkGray
        
        addSubview(itemImage)
        itemImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addSubview(loading)
        loading.startAnimating()
        loading.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 5
        clipsToBounds = true
    }
    
    private func removeBorder() {
        layer.borderWidth = 0
        layer.borderColor = nil
    }
}

protocol CellItemDelegate {
    func didSelect(item: Item)
}
