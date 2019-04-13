////
//  InventoryViewController.swift
//  Mooch
//
//  Created by App Center on 3/19/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit
import LDLogger

class InventoryViewController: UIViewController, Storyboarded {

    var coordinator: MainCoordinator!
    var inventoryItems: [Item] = []
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Inventory"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        setupView()
        setupCollectionView()
    }
    
    var firstLoad = true
    override func viewWillAppear(_ animated: Bool) {
        coordinator.navigationController.isNavigationBarHidden = true
        if firstLoad {
            setupIndicator()
            getInventoryData()
            firstLoad = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        loadedImageCounter = 0
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
        self.collectionView = collectionView
        
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
    
    private var loadedImageCounter = 0 {
        didSet {
            if self.loadedImageCounter == self.inventoryItems.count {
                self.indicator?.stopAnimating()
            }
        }
    }
    
    private var indicator: UIActivityIndicatorView?
    private func getInventoryData() {
        Session.shared.updateDataForCurrentUser { (items) in
            DispatchQueue.main.async {
                self.inventoryItems = items
                self.collectionView.reloadData()
            }
        }
    }
    private func setupIndicator() {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = EKColor.Mooch.lightBlue
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        self.indicator = indicator
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        indicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    @objc func addItem(sender: UIBarButtonItem) {
        coordinator.chooseCreateMethod()
    }
}

extension InventoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inventoryItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath)
        
        cell.backgroundColor = .lightGray
        cell.layer.cornerRadius = 5
        
        let item = inventoryItems[indexPath.row]
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 5
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        
        if item.checkForImagesInCache().count > 0 {
            DispatchQueue.main.async {
                do {
                    let img = try Session.shared.cache.getImageFrom(itemID: item.id, imageID: "img-0")
                    imgView.image = img
                    cell.addSubview(imgView)
                    imgView.snp.makeConstraints { (make) in
                        make.edges.equalToSuperview()
                    }
                    self.loadedImageCounter += 1
                    Log.d("Loaded Images: \(self.loadedImageCounter) of \(self.inventoryItems.count)")
                    self.collectionViewCell(didFinishLoadingAt: indexPath)
                } catch {
                    Log.e(error)
                }
            }
        } else {
            item.downloadImages { (done) in
                DispatchQueue.main.async {
                    do {
                        let img = try Session.shared.cache.getImageFrom(itemID: item.id, imageID: "img-0")
                        imgView.image = img
                        cell.addSubview(imgView)
                        imgView.snp.makeConstraints { (make) in
                            make.edges.equalToSuperview()
                        }
                        self.loadedImageCounter += 1
                        Log.d("Loaded Images: \(self.loadedImageCounter) of \(self.inventoryItems.count)")
                        self.collectionViewCell(didFinishLoadingAt: indexPath)
                    } catch {
                        Log.e(error)
                    }
                }
            }
        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let item = self.inventoryItems[indexPath.row]
        coordinator.showItemDetail(for: item)
    }
    
    func collectionViewCell(didFinishLoadingAt indexPath: IndexPath) {
        if self.loadedImageCounter == inventoryItems.count {
            guard let view = self.indicator else { return }
            DispatchQueue.main.async {
                view.stopAnimating()
            }
        }
    }
    
}
