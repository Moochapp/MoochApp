////
//  SelectFavoritesViewController.swift
//  Mooch
//
//  Created by App Center on 4/25/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit

class SelectFavoritesViewController: UIViewController {

    static let cellID = "cell"
    
    var coordinator: MainCoordinator!
    
    var categories: [String: UIImage]!
    var keys: [String] = []
    var selectedItems: [String : Bool] = [:]
    
    var collectionView: UICollectionView!
    var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = EKColor.Mooch.darkGray
        initNavbar()
        initDataSource()
        initCollectionView()
        
    }
    
    func initCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide).inset(8)
        }
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: SelectFavoritesViewController.cellID)
        collectionView.backgroundColor = EKColor.Mooch.darkGray
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func initDataSource() {
        let categoryTitles = StockImageLoader.shared.getCategories()
        let images = StockImageLoader.shared.getMainCategoryImages()
        
        self.keys = categoryTitles.sorted()
        self.categories = images
    }
    
    func initNavbar() {
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        doneButton.isEnabled = false
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func showError() {
        
    }
    
    private func toggleDoneButton(count: Int) {
        if count == 3 {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
    }
    
    @objc private func done() {
        doneButton.isEnabled = false
        let categories = selectedItems.filter { (item) -> Bool in
            return item.value == true
        }.keys
        Session.shared.moocher.favoriteCategories = Array(categories)
        Session.shared.moocher.syncChanges { (error) in
            guard error == nil else {
                print("ERRPR:", error!.localizedDescription)
                self.doneButton.isEnabled = true
                return
            }
            self.coordinator.mainApp()
        }
    }

}

extension SelectFavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectFavoritesViewController.cellID, for: indexPath)
        
        let title = keys[indexPath.row]
        let imageView = UIImageView(image: self.categories[title])
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        cell.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let mask = UIView()
        mask.backgroundColor = .black
        mask.clipsToBounds = true
        mask.layer.cornerRadius = 5
        mask.alpha = 0.25
        cell.addSubview(mask)
        
        mask.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = title
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .white
        titleLabel.adjustsFontSizeToFitWidth = true
        cell.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview().inset(4)
        }
        
        let checked = UIImageView(image: #imageLiteral(resourceName: "CheckBox"))
        
        let category = keys[indexPath.row]
        if let toggle = selectedItems[category] {
            if toggle {
                // Toggle on
                cell.addSubview(checked)
                checked.snp.makeConstraints { (make) in
                    make.center.equalToSuperview()
                    make.height.width.equalTo(50)
                }
            } else {
                // Toggle off
                checked.snp.removeConstraints()
                checked.removeFromSuperview()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = keys[indexPath.row]
        
        let count = selectedItems.filter { (item) -> Bool in
            return item.value == true
        }.count
        
        let generator = UINotificationFeedbackGenerator()
        
        if let toggle = selectedItems[category] {
            if toggle {
                // Toggle off
                selectedItems[category] = false
                toggleDoneButton(count: count - 1)
                collectionView.reloadItems(at: [indexPath])
                generator.notificationOccurred(.success)
            } else {
                // Toggle on
                guard count < 3 else {
                    generator.notificationOccurred(.error)
                    return
                }
                selectedItems[category] = true
                toggleDoneButton(count: count + 1)
                collectionView.reloadItems(at: [indexPath])
                generator.notificationOccurred(.success)
            }
        } else {
            // Toggle on
            guard count < 3 else {
                generator.notificationOccurred(.error)
                return
            }
            selectedItems[category] = true
            toggleDoneButton(count: count + 1)
            collectionView.reloadItems(at: [indexPath])
            generator.notificationOccurred(.success)
        }
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
}
