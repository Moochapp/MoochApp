////
//  ExploreViewModel.swift
//  Mooch
//
//  Created by App Center on 3/4/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import UIKit

class ExploreViewModel: ExploreDataObjectDelegate {
    
    init(viewController: ExploreViewController) {
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
        for _ in ExploreViewModel.categoryData.data.keys {
            let random = Int.random(in: 0...11)
            category.append(imgs[random])
        }
        var keys = Array(ExploreViewModel.categoryData.data.keys)
        keys.sort()
        self.categoryData = CategoriesDataObject(titles: keys, images: category)
        self.vc = viewController
    }
    
    weak var vc: ExploreViewController?
    var images: [UIImage]
    var names = ["Tools", "Electronics", "Books"]
    let categories = ["Books", "Household", "Tools", "Fashion", "Sports", "Music", "Office", "Cash", "Event Space", "Baby",
                      "Party/Event", "Transport", "Movies", "Health", "School", "Scoop", "Misc", "Electronics"]
    static let categoryData = CategoryData()
    
    var featuredData: FeaturedDataObject
    var favoritesData: FavoritesDataObject
    var categoryData: CategoriesDataObject
    
    func setDelegatesForDataObjectManagers() {
        categoryData.delegate = self
    }
    
    func didSelectItem(category: String, image: UIImage) {
        vc?.coordinator.showSubCategories(with: category, image: image)
    }
    
}

struct CategoryData {
    let demoImages: [UIImage] = {
        var imgs: [UIImage] = []
        for i in 1...12 {
            if let image = UIImage(named: "Demo-\(i)") {
                imgs.append(image)
            }
        }
        return imgs
    }()
    let data = ["Books": [
                    "Spiritual"
                ],
                "Fashion": [
                    "Shoes",
                    "Jewelry"
                ],
                "Sporting Goods": [
                    "Hunting",
                    "Fishing",
                    "Bike",
                    "Sports",
                    "Misc"
                ],
                "Entertainment": [
                    "Music",
                    "Movies",
                    "Tickets",
                    "Video Games",
                    "CD",
                    "Games"
                ],
                "Services": [
                    "Hair and Makeup",
                    "Photography",
                    "Artist & Entertainers",
                    "Tutors",
                    "Fitness Instruction",
                    "Interior Design",
                    "Organization",
                    "Real Estate"
                ],
                "Tools": [
                    "Air Tools & Compressors",
                    "Automotive",
                    "Cleaning",
                    "Concrete",
                    "Electrical",
                    "Generators",
                    "Hand Tools",
                    "Hand Trucks And Dollies",
                    "Ladders",
                    "Lawn And Garden"
                ],
                "Baby": [],
                "Electronics": [
                    "Phototgraphy",
                    "Phone",
                    "Computer",
                    "Tablet"
                ],
                "Transportation": [],
                "Household": [],
                "Office": [],
                "Event": [],
                "Space": [],
                "Health": [],
                "Misc": [],
                "Furniture": [],
                "Pets": [],
                "Art": []
    ]
}
