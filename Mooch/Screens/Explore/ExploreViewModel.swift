////
//  ExploreViewModel.swift
//  Mooch
//
//  Created by App Center on 3/4/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import UIKit

class ExploreViewModel {
    
    var images: [UIImage]
    var names = ["Tools", "Electronics", "Books"]
    let categories = ["Books", "Household", "Tools", "Fashion", "Sports", "Music", "Office", "Cash", "Event Space", "Baby",
                      "Party/Event", "Transport", "Movies", "Health", "School", "Scoop", "Misc", "Electronics"]
    
    var featuredData: FeaturedDataObject
    var favoritesData: FavoritesDataObject
    var categoryData: CategoriesDataObject
    
    init() {
        // This needs to be replaced with images for stock photos
        var imgs: [UIImage] = []
        for i in 1...12 {
            if let image = UIImage(named: "Demo-\(i)") {
                imgs.append(image)
            }
        }
        self.images = imgs
        
        self.featuredData = FeaturedDataObject(images: imgs)
        self.favoritesData = FavoritesDataObject(images: [imgs[5], imgs[7], imgs[8]])
        
        var category: [UIImage] = []
        for item in categories {
            let random = Int.random(in: 0...11)
            category.append(imgs[random])
        }
        self.categoryData = CategoriesDataObject(titles: self.categories, images: category)
        
    }
    
}
