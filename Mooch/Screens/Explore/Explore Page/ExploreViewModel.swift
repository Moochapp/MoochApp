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
                "Psycology",
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
                "Bikes",
                "Bowling",
                "Boxing/Mma",
                "Camping/Hiking",
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
                "Travel",
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
                "Offfice",
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
