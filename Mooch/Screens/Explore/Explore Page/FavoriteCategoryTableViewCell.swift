////
//  FavoriteCategoryTableViewCell.swift
//  Mooch
//
//  Created by App Center on 4/29/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit

class FavoriteCategoryTableViewCell: UITableViewCell {

    var category: String = ""
    var categoryImage: UIImage = UIImage()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}