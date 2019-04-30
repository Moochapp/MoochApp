////
//  CategoriesTableViewCell.swift
//  Mooch
//
//  Created by App Center on 4/29/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {

    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        categoriesCollectionView.delegate = self
//        categoriesCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//extension CategoriesTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//    }
//
//
//}
