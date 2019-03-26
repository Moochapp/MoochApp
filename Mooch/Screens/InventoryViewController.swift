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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .clear
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.01112855412, green: 0.7845740914, blue: 0.9864193797, alpha: 1)
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem(sender:)))
        addItem.tintColor = .white
        coordinator.navigationController.navigationItem.rightBarButtonItem = addItem
        
    }
    
    @objc func addItem(sender: UIBarButtonItem) {
        print("Nice!")
    }
    
}

extension InventoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .lightGray
        
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
}
