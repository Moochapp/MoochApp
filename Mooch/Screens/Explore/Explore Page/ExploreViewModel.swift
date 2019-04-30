////
//  ExploreViewModel.swift
//  Mooch
//
//  Created by App Center on 3/4/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import UIKit
import LDLogger

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
        
        let favoriteCats = Session.shared.moocher.favoriteCategories
        var categoryImages = StockImageLoader.shared.getMainCategoryImages()
        for category in favoriteCats {
            if let image = categoryImages[category] {
                favorites[category] = image
            } else {
                print("ERROR")
            }
        }
        
//        self.categoryData = CategoriesDataObject(titles: categories, images: category)
        self.categoryData = CategoriesDataObject(categoryData: StockImageLoader.shared.getMainCategoryImages())
        self.vc = viewController
    }
    
    weak var vc: ExploreViewController?
    var images: [UIImage]
    var favorites: [String: UIImage] = [:]
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
        let subcategories = StockImageLoader.shared.getSubcategories(for: category)
        var subData: [String: UIImage] = [:]
        for sub in subcategories {
            if let image = StockImageLoader.shared.getImage(category: category, subcategory: sub) {
                subData[sub] = image
            }
        }
        vc?.showProgressIndicator(completion: { (activity) in
            Item.getResults(for: category) { (error, subCategoryItems) in
                DispatchQueue.main.async {
                    activity.stopAnimating()
                    guard error == nil else {
                        Log.d(error!.localizedDescription)
                        return
                    }
                    guard let subCategoryItems = subCategoryItems else {
                        Log.d("Couldn't get items")
                        return
                    }
                    self.vc?.coordinator.showSubCategories(forCategory: category, withData: subData, andItems: subCategoryItems)
                }
            }
        })
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
    let data: [String: [String]] = [
        "Books": [
            "Religion",
            "Biography",
            "Business",
            "Cookbook",
            "Health",
            "Fiction",
            "History",
            "Comic",
            "Mystery & Crime",
            "Scifi",
            "Thrillers",
            "Westerns",
            "Kids",
            "Teens",
            "Textbooks",
            "Medicine",
            "Psychology",
            "Science",
            "Law",
            "Education",
            "Computer",
            "Accounting",
            "Math",
            "Art",
            "Misc"],
        "Fashion": [
            "Shoes",
            "Jewelry",
            "Dresses",
            "Rompers",
            "Tops",
            "Shorts",
            "Skirts",
            "Pants",
            "Jackets",
            "Sweaters",
            "Activewear",
            "Jeans",
            "Handbags",
            "Accessories",
            "Kids",
            "Baby",
            "Misc"],
        "Sporting Goods": [
            "Hunting",
            "Fishing",
            "Bike",
            "Sports",
            "Misc",
            "Baseball",
            "Basketball",
            "Bowling",
            "Boxing / MMA",
            "Camping / Hiking",
            "Cheerleading",
            "Climbing",
            "Cricket",
            "Fitness",
            "Field Hockey",
            "Fishing",
            "Football",
            "Golf",
            "Gymnastics",
            "Handball",
            "Hockey",
            "Hunting",
            "Skate",
            "Lacrosse",
            "Rugby",
            "Running",
            "Soccer",
            "Softball",
            "Swimming",
            "Table Tennis",
            "Track & Field",
            "Volleyball",
            "Watersports",
            "Wellness",
            "Winter Sports",
            "Wrestling",
            "Yoga"],
        "Entertainment": [
            "Music",
            "Movies",
            "Tickets",
            "Video Games",
            "Cd",
            "Boardgames",
            "Misc"],
        "Services": [
            "Hair And Makeup",
            "Photography",
            "Artist & Entertainers",
            "Tutors",
            "Fitness Instruction",
            "Interior Design",
            "Organization",
            "Real Estate",
            "Printing",
            "Pet",
            "Lawn",
            "Misc"],
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
            "Lawn And Garden",
            "Flashlights",
            "Levels",
            "Measure",
            "Power",
            "Vaccuum",
            "Storage",
            "Welding",
            "Misc"],
        "Baby": [
            "Strollers",
            "Car Seats",
            "Safety",
            "Bath",
            "Shoes",
            "Clothing",
            "Misc"],
        "Electronics": [
            "Phototgraphy",
            "Phone",
            "Computer",
            "Tablet",
            "Appliances",
            "TV",
            "Speakers",
            "Camera",
            "Video",
            "Cell Phone",
            "Audio",
            "Video Game",
            "Movies",
            "Car Eletronics",
            "GPS",
            "Health",
            "Security",
            "Drones",
            "Toys",
            "Misc"],
        "Transportation": [
            "Bike",
            "Scooter",
            "Car",
            "Boat",
            "Air",
            "Misc"],
        "Household": [
            "Kitchen",
            "Bedding",
            "Dining",
            "Storage",
            "Cleaning",
            "Décor",
            "Bath",
            "Table",
            "Chairs",
            "Furniture",
            "Curtains",
            "Outdoor",
            "Kids",
            "Beauty",
            "Luggage",
            "Pet",
            "Misc"],
        "Office": [
            "Office Supplies",
            "Paper",
            "Ink",
            "Furniture",
            "Cleaning",
            "School ",
            "Printing",
            "Copy",
            "Workspace",
            "Misc"],
        "Event Space": [
            "Birthday",
            "Conversation",
            "Activity",
            "Misc"],
        "Health": [
            "Beauty",
            "Personal Care",
            "Home Health",
            "Medical Supply",
            "Misc"],
        "Furniture": [
            "Living",
            "Bedroom",
            "Mattresses",
            "Dining",
            "Office",
            "Outdoor",
            "Décor",
            "Rugs",
            "Misc"],
        "Pets": [
            "Dog",
            "Cat ",
            "Fish ",
            "Bird",
            "Reptile",
            "Horse",
            "Cattle",
            "Misc"]]
}
