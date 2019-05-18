////
//  StockImageLoader.swift
//  Mooch
//
//  Created by App Center on 4/22/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import UIKit

struct StockImageLoader {
    static var shared = StockImageLoader()
    
    func getCategories() -> [String] {
        let keys = categoryImages.keys
        var keyss: [String] = []
        for key in keys {
            keyss.append(key)
        }
        return keyss
    }
    func getSubcategories(for category: String) -> [String] {
        guard let subs = categoryImages[category] else { return [] }
        let keys = subs.keys
        var keyys: [String] = []
        for key in keys {
            keyys.append(key)
        }
        return keyys
    }
    func getImage(category: String, subcategory: String) -> UIImage? {
        if let img = categoryImages[category]?[subcategory] {
            if let image = img {
                return image
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    func getRandomImage(in category: String) -> UIImage? {
        if let subs = categoryImages[category] {
            let keys = Array(subs.keys)
            let randomKey = Int.random(in: 0..<keys.count)
            let key = keys[randomKey]
            if let img = subs[key] {
                if let image = img {
                    return image
                }
            }
        }
        return nil
    }
    func getMainCategoryImages() -> [String: UIImage] {
        var data: [String: UIImage] = [:]
        let categories = getCategories()
        for title in categories {
            let imageName = "mainCat - \(title)"
            if let image = UIImage(named: imageName) {
                data[title] = image
            } else {
                print("Could not get image for name: \(title)")
            }
        }
        return data
    }
    
    let categoryImages: [String: [String: UIImage?]] = [
        "Baby": ["Bath": UIImage(named: "Bath.jpg"),
                "Car Seats": UIImage(named: "Car Seats.jpg"),
                "Clothing": UIImage(named: "Clothing - Baby"),
                "Misc": UIImage(named: "Misc Baby.jpg"),
                "Safety": UIImage(named: "Safety.jpg"),
                "Shoes": UIImage(named: "Shoes.jpg"),
                "Strollers": UIImage(named: "Strollers.jpg")],
        "Books": ["Accounting": UIImage(named: "Accounting.jpg"),
                 "Art": UIImage(named: "Art.jpg"),
                 "Biography": UIImage(named: "Biography.jpg"),
                 "Business": UIImage(named: "Business.jpg"),
                 "Comic": UIImage(named: "Comic.jpg"),
                 "Computer": UIImage(named: "Computer.jpg"),
                 "Cookbook": UIImage(named: "Cookbook.jpg"),
                 "Education": UIImage(named: "Education.jpg"),
                 "Fiction": UIImage(named: "Fiction.jpg"),
                 "Health": UIImage(named: "Health.jpg"),
                 "History": UIImage(named: "History.jpg"),
                 "Kids": UIImage(named: "Kids.jpg"),
                 "Law": UIImage(named: "Law.jpg"),
                 "Math": UIImage(named: "Math.jpg"),
                 "Medicine": UIImage(named: "Medicine.jpg"),
                 "Misc": UIImage(named: "Misc.jpg"),
                 "Mystery & Crime": UIImage(named: "Mystery & Crime.jpg"),
                 "Psychology": UIImage(named: "Psychology.jpg"),
                 "Religion": UIImage(named: "Religion.jpg"),
                 "Science": UIImage(named: "Science.jpg"),
                 "SciFi": UIImage(named: "Scifi.jpg"),
                 "Teens": UIImage(named: "Teens.jpg"),
                 "Textbooks": UIImage(named: "Textbooks.jpg"),
                 "Thrillers": UIImage(named: "Thrillers.jpg"),
                 "Westerns": UIImage(named: "Westerns.jpg")],
        "Electronics": ["Appliances": UIImage(named: "Appliances.jpg"),
                       "Audio": UIImage(named: "Audio.jpg"),
                       "Camera": UIImage(named: "Camera.jpg"),
                       "Car Electronics": UIImage(named: "Car Electronics.jpg"),
                       "Cell Phone": UIImage(named: "Cell Phone.jpg"),
                       "Computer": UIImage(named: "Computer.jpg"),
                       "Drones": UIImage(named: "Drones.jpg"),
                       "GPS": UIImage(named: "GPS.jpg"),
                       "Health": UIImage(named: "Health.jpg"),
                       "Misc": UIImage(named: "Misc - Electronics.jpg"),
                       "Movies": UIImage(named: "Movies.jpg"),
                       "Phone": UIImage(named: "Phones"),
                       "Photography": UIImage(named: "Photography - Electronics.jpg"),
                       "Security": UIImage(named: "Security.jpg"),
                       "Speakers": UIImage(named: "Speakers.jpg"),
                       "TV": UIImage(named: "TV.jpg"),
                       "Tablet": UIImage(named: "Tablet.jpg"),
                       "Toys": UIImage(named: "Toys.jpg"),
                       "Video": UIImage(named: "Video.jpg"),
                       "Video Game": UIImage(named: "Video Games.jpg")],
        "Entertainment": ["Boardgames": UIImage(named: "Boardgames.jpg"),
                         "Cd": UIImage(named: "Cd.jpg"),
                         "Misc": UIImage(named: "Misc Entertainment.jpg"),
                         "Movies": UIImage(named: "Movies.jpg"),
                         "Music": UIImage(named: "Music.jpg"),
                         "Tickets": UIImage(named: "Tickets.jpg"),
                         "Video Games": UIImage(named: "Video Games.jpg")],
        "Event Space": ["Activity": UIImage(named: "Activity.jpg"),
                       "Birthday": UIImage(named: "Birthday.jpg"),
                       "Conversation": UIImage(named: "Conversation.jpg"),
                       "Misc": UIImage(named: "Misc - Event Space.jpg")],
        "Fashion": ["Accessories": UIImage(named: "Accessories.jpg"),
                   "Activewear": UIImage(named: "Activewear.jpg"),
                   "Baby": UIImage(named: "Baby.jpg"),
                   "Dresses": UIImage(named: "Dresses.jpg"),
                   "Handbags": UIImage(named: "Handbags.jpg"),
                   "Jackets": UIImage(named: "Jackets.jpg"),
                   "Jeans": UIImage(named: "Jeans.jpg"),
                   "Jewelry": UIImage(named: "Jewelry.jpg"),
                   "Kids": UIImage(named: "Kids.jpg"),
                   "Misc": UIImage(named: "Misc - Fashion.jpg"),
                   "Pants": UIImage(named: "Pants.jpg"),
                   "Rompers": UIImage(named: "Rompers.jpg"),
                   "Shoes": UIImage(named: "Shoes.jpg"),
                   "Shorts": UIImage(named: "Shorts.jpg"),
                   "Skirts": UIImage(named: "Skirts.jpg"),
                   "Sweaters": UIImage(named: "Sweaters.jpg"),
                   "Tops": UIImage(named: "Tops.jpg")],
        "Furniture": ["Bedroom": UIImage(named: "Bedroom.jpg"),
                     "Dining": UIImage(named: "Dining.jpg"),
                     "Décor": UIImage(named: "Decor - Furniture.jpg"),
                     "Living": UIImage(named: "Living.jpg"),
                     "Mattresses": UIImage(named: "Mattresses.jpg"),
                     "Misc": UIImage(named: "Misc - Furniture.jpg"),
                     "Office": UIImage(named: "Office - Furniture"),
                     "Outdoor": UIImage(named: "Outdoor - Furnature.jpg"),
                     "Rugs": UIImage(named: "Rugs.jpg")],
        "Health": ["Beauty": UIImage(named: "Beauty - Health.jpg"),
                  "Home Health": UIImage(named: "Home Health.jpg"),
                  "Medical Supply": UIImage(named: "Medical Supply.jpg"),
                  "Misc": UIImage(named: "Misc - Health.jpg"),
                  "Personal Care": UIImage(named: "Personal Care.jpg")],
        "Household": ["Bath": UIImage(named: "Bath - Household.jpg"),
                     "Beauty": UIImage(named: "Beauty - Household.jpg"),
                     "Bedding": UIImage(named: "Bedding.jpg"),
                     "Chairs": UIImage(named: "Chairs.jpg"),
                     "Cleaning": UIImage(named: "Cleaning.jpg"),
                     "Curtains": UIImage(named: "Curtains.jpg"),
                     "Dining": UIImage(named: "Dining.jpg"),
                     "Décor": UIImage(named: "Decor.jpg"),
                     "Furniture": UIImage(named: "Furniture.jpg"),
                     "Kids": UIImage(named: "Kids.jpg"),
                     "Kitchen": UIImage(named: "Kitchen.jpg"),
                     "Luggage": UIImage(named: "Luggage.jpg"),
                     "Misc": UIImage(named: "Misc - Household.jpg"),
                     "Outdoor": UIImage(named: "Outdoor.jpg"),
                     "Pet": UIImage(named: "Pet.jpg"),
                     "Storage": UIImage(named: "Storage.jpg"),
                     "Table": UIImage(named: "Table.jpg")],
        "Office": ["Cleaning": UIImage(named: "Cleaning.jpg"),
                  "Copy": UIImage(named: "Copy.jpg"),
                  "Furniture": UIImage(named: "Furniture.jpg"),
                  "Ink": UIImage(named: "Ink.jpg"),
                  "Misc": UIImage(named: "Misc - Office.jpg"),
                  "Office Supplies": UIImage(named: "Office Supplies.jpg"),
                  "Paper": UIImage(named: "Paper.jpg"),
                  "Printing": UIImage(named: "Printing.jpg"),
                  "School ": UIImage(named: "School - Office.jpg"),
                  "Workspace": UIImage(named: "Workspace.jpg")],
        "Pets": ["Bird": UIImage(named: "Bird.jpg"),
                "Cat ": UIImage(named: "Cat.jpg"),
                "Cattle": UIImage(named: "Cattle.jpg"),
                "Dog": UIImage(named: "Dog.jpg"),
                "Fish ": UIImage(named: "Fish.jpg"),
                "Horse": UIImage(named: "Horse.jpg"),
                "Misc": UIImage(named: "Misc Pets.jpg"),
                "Reptile": UIImage(named: "Reptile.jpg")],
        "Services": ["Artist & Entertainers": UIImage(named: "Artist And Entertainers.jpg"),
                    "Fitness Instruction": UIImage(named: "Fitness Instruction.jpg"),
                    "Hair And Makeup": UIImage(named: "Hair And Makeup.jpg"),
                    "Interior Design": UIImage(named: "Interior Design.jpg"),
                    "Lawn": UIImage(named: "Lawn.jpg"),
                    "Misc": UIImage(named: "Misc Services.jpg"),
                    "Organization": UIImage(named: "Organization.jpg"),
                    "Pet": UIImage(named: "Pet.jpg"),
                    "Photography": UIImage(named: "Photography.jpg"),
                    "Printing": UIImage(named: "Printing.jpg"),
                    "Real Estate": UIImage(named: "Real Estate.jpg"),
                    "Tutors": UIImage(named: "Tutors.jpg")],
        "Sporting Goods": ["Baseball": UIImage(named: "Baseball.jpg"),
                          "Basketball": UIImage(named: "Basketball.jpg"),
                          "Bike": UIImage(named: "Bike.jpg"),
                          "Bowling": UIImage(named: "Bowling.jpg"),
                          "Boxing / MMA": UIImage(named: "Boxing / MMA.jpg"),
                          "Camping / Hiking": UIImage(named: "Camping / Hiking.jpg"),
                          "Cheerleading": UIImage(named: "Cheerleading.jpg"),
                          "Climbing": UIImage(named: "Climbing.jpg"),
                          "Cricket": UIImage(named: "Cricket.jpg"),
                          "Field Hockey": UIImage(named: "Field Hockey.jpg"),
                          "Fishing": UIImage(named: "Fishing.jpg"),
                          "Fitness": UIImage(named: "Fitness.jpg"),
                          "Football": UIImage(named: "Football.jpg"),
                          "Golf": UIImage(named: "Golf.jpg"),
                          "Gymnastics": UIImage(named: "Gymnastics.jpg"),
                          "Handball": UIImage(named: "Handball.jpg"),
                          "Hockey": UIImage(named: "Hockey.jpg"),
                          "Hunting": UIImage(named: "Hunting.jpg"),
                          "Lacrosse": UIImage(named: "Lacrosse.jpg"),
                          "Misc": UIImage(named: "Misc Sporing Goods.jpg"),
                          "Rugby": UIImage(named: "Rugby.jpg"),
                          "Running": UIImage(named: "Running.jpg"),
                          "Skate": UIImage(named: "Skate.jpg"),
                          "Soccer": UIImage(named: "Soccer.jpg"),
                          "Softball": UIImage(named: "Softball.jpg"),
                          "Sports": UIImage(named: "Sports.jpg"),
                          "Swimming": UIImage(named: "Swimming.jpg"),
                          "Table Tennis": UIImage(named: "Table Tennis.jpg"),
                          "Track & Field": UIImage(named: "Track & Field.jpg"),
                          "Volleyball": UIImage(named: "Volleyball.jpg"),
                          "Water Sports": UIImage(named: "Watersports.jpg"),
                          "Wellness": UIImage(named: "Wellness.jpg"),
                          "Winter Sports": UIImage(named: "Winter Sports.jpg"),
                          "Wrestling": UIImage(named: "Wrestling.jpg"),
                          "Yoga": UIImage(named: "Yoga.jpg")],
        "Tools": ["Air Tools & Compressors": UIImage(named: "Air Tools & Compressors.jpg"),
                 "Automotive": UIImage(named: "Automotive.jpg"),
                 "Cleaning": UIImage(named: "Cleaning.jpg"),
                 "Concrete": UIImage(named: "Concrete.jpg"),
                 "Electrical": UIImage(named: "Electrical.jpg"),
                 "Flashlights": UIImage(named: "Flashlights.jpg"),
                 "Generators": UIImage(named: "Generators.jpg"),
                 "Hand Tools": UIImage(named: "Hand Tools.jpg"),
                 "Hand Trucks And Dollies": UIImage(named: "Hand Trucks And Dollies.jpg"),
                 "Ladders": UIImage(named: "Ladders.jpg"),
                 "Lawn And Garden": UIImage(named: "Lawn And Garden.jpg"),
                 "Levels": UIImage(named: "Levels.jpg"),
                 "Measure": UIImage(named: "Measure.jpg"),
                 "Misc": UIImage(named: "Misc Tools.jpg"),
                 "Power": UIImage(named: "Power.jpg"),
                 "Storage": UIImage(named: "Storage.jpg"),
                 "Vacuum": UIImage(named: "Vacuum.jpg"),
                 "Welding": UIImage(named: "Welding.jpg")],
        "Transportation": ["Air": UIImage(named: "Air.jpg"),
                          "Bike": UIImage(named: "Bike.jpg"),
                          "Boat": UIImage(named: "Boat.jpg"),
                          "Car": UIImage(named: "Car.jpg"),
                          "Misc": UIImage(named: "Misc - Transportation.jpg"),
                          "Scooter": UIImage(named: "Scooter.jpg")]]

}
