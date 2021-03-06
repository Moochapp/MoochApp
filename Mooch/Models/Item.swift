////
//  Item.swift
//
//  Created by App Center on 12/28/18.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import FirebaseFirestore
import LDLogger

class Item {
    var id: String
    var timestamp: Timestamp
    var name: String
    var category: String
    var subcategory: String
    var owner: String
    var numberOfImages: Int = 0
    var images: [UIImage] = []
    var availableFor: [Availability: Bool] = [.buy: false, .rent: false, .mooch: false]
    var rentalFee: Double?
    var rentalInterval: String?
    var price: Double?
    var status: Status = .available
    var likes: Int = 0
    
    enum Availability: String {
        case mooch = "mooch"
        case rent = "rent"
        case buy = "buy"
    }
    enum Status: String {
        case available = "available"
        case unavailable = "unavailable"
    }
    
    public init() {
        self.id = ""
        self.timestamp = Date().getFirebaseDate()
        self.name = ""
        self.category = ""
        self.subcategory = ""
        self.owner = ""
        self.images = []
    }
    
    public convenience init(document: DocumentSnapshot) {
        self.init()
        if let itemData = document.data() {
            self.id = itemData["ID"] as! String
            self.timestamp = itemData["Timestamp"] as! Timestamp
            self.name = itemData["Name"] as! String
            self.category = itemData["Category"] as! String
            self.subcategory = itemData["Subcategory"] as! String
            self.owner = itemData["Owner"] as! String
            self.rentalFee = itemData["RentalFee"] as? Double
            self.rentalInterval = itemData["RentalInterval"] as? String
            self.price = itemData["Price"] as? Double
            self.likes = itemData["Likes"] as! Int
            self.numberOfImages = itemData["NumberOfImages"] as! Int
            
            if let status = Status(rawValue: itemData["Status"] as! String) {
                self.status =  status
            }
            
            if let availableForSet = itemData["AvailableFor"] as? [String: Bool] {
                for item in availableForSet {
                    if item.key == Availability.buy.rawValue {
                        self.availableFor[.buy] = item.value
                    } else if item.key == Availability.mooch.rawValue {
                        self.availableFor[.mooch] = item.value
                    } else if item.key == Availability.rent.rawValue {
                        self.availableFor[.rent] = item.value
                    }
                }
            }
            
        } else {
            fatalError("Missing data. Should have complete item data.")
        }
    }
    
    public func upload(progress: @escaping (Int, Double)->(), completion: @escaping (Error?)->()) {
        let ref = FirebaseManager.items.document()
        self.id = ref.documentID
        self.numberOfImages = self.images.count
        let data = toDictionary()
        DispatchQueue.global(qos: .userInitiated).async {
            var errors: [Int: Error?] = [:]
            let uploadGroup = DispatchGroup()
            
            for (index, image) in self.images.enumerated() {
                uploadGroup.enter()
                
                let name = "img-\(index).png"
                
                self.uploadImage(itemID: self.id, name: name, image: image, progress: { (completed) in
                    progress(index, completed)
                }, completion: { (error) in
                    errors[index] = error
                    uploadGroup.leave()
                })
                
            }
            
            uploadGroup.wait()
            
            ref.setData(data, completion: { (error) in
                guard error == nil else {
                    completion(error)
                    return
                }
                completion(nil)
            })
            
        }
    }
    
    public func downloadImages(completion: @escaping (Bool)->(), thumbnail: @escaping (UIImage)->()) {
        DispatchQueue.global(qos: .userInitiated).async {
            let group = DispatchGroup()
            for index in 0...self.numberOfImages - 1 {
                group.enter()
                let name = "img-\(index).png"
                Log.i("Starting download for:", self.id, name)
                self.download(ID: self.id, name: name, completion: { (image) in
                    self.images.append(image)
                    Log.d("Downloaded image:", self.id, name)
                    do {
                        Log.d("Attempting cache for", self.id, name)
                        try Session.shared.cache.addToCache(image: image, itemID: self.id, imageID: "img-\(index)")
                        group.leave()
                    } catch {
                        Log.e(error)
                        group.leave()
                    }
                    
                    if index == 0 {
                        thumbnail(image)
                    }
                })
            }
            group.wait()
            completion(true)
        }
        
    }
    
    private func download(ID: String, name: String, completion: @escaping (UIImage)->()) {
        
        FirebaseManager.storage.reference().child("Items").child(ID).child(name).getData(maxSize: 1024 * 1024 * 20) { (data, error) in
            guard error == nil else {
                Log.e(error!.localizedDescription)
                return
            }
            guard let data = data else {
                return
            }
            guard let img = UIImage(data: data) else {
                return
            }
            
            completion(img)
        }
    }
    
    private func uploadImage(itemID: String, name: String, image: UIImage, progress: @escaping (Double)->(), completion: @escaping (Error?)->()) {
        let data = image.pngData()!
        let ref = FirebaseManager.storage.reference().child("Items").child(itemID).child(name)
        let task = ref.putData(data, metadata: nil) { (metadata, error) in
            guard error == nil else {
                completion(error) // Error on upload
                return
            }
            completion(nil) // all went as planned
        }
        task.observe(.progress) { (snapshot) in
            if let completed = snapshot.progress?.fractionCompleted {
                progress(completed)
            }
        }
    }
    
    private func toDictionary() -> [String: Any] {
        
        let availFor = [Availability.buy.rawValue: availableFor[.buy]!,
                        Availability.rent.rawValue: availableFor[.rent]!,
                        Availability.mooch.rawValue: availableFor[.mooch]!]
        
        let data: [String : Any] = ["ID": self.id,
                                    "Name": self.name,
                                    "Category": self.category,
                                    "Subcategory": self.subcategory,
                                    "Owner": self.owner,
                                    "NumberOfImages": self.numberOfImages,
                                    "AvailableFor": availFor,
                                    "RentalFee": self.rentalFee as Any,
                                    "RentalInterval": self.rentalInterval as Any,
                                    "Price": self.price as Any,
                                    "Status": self.status.rawValue,
                                    "Likes": self.likes,
                                    "Timestamp": self.timestamp]
        
        return data
    }
    
    public func checkForImagesInCache() -> [UIImage] {
        var images: [UIImage] = []
        for i in 0...numberOfImages - 1 {
            let name  = "img-\(i)"
            do {
                let image = try Session.shared.cache.getImageFrom(itemID: id, imageID: name)
                images.append(image)
            } catch {
                Log.e(error)
                return images
            }
        }
        return images
    }
    
    static func getResults(for category: String, results: @escaping (Error?, [String: [Item]]?)->()) {
        let subs = StockImageLoader.shared.getSubcategories(for: category)
        DispatchQueue.global(qos: .userInitiated).async {
            var categoryItems: [String: [Item]] = [:]
            
            let group = DispatchGroup()
            for subcat in subs {
                group.enter()
                FirebaseManager.items
                    .whereField("Category", isEqualTo: category)
                    .whereField("Subcategory", isEqualTo: subcat)
                    .limit(to: 5).getDocuments(completion: { (snap, error) in
                        guard error == nil else {
                            results(error, nil)
                            return
                        }
                        
                        guard let snap = snap else {
                            results(nil, nil)
                            return
                        }
                        
                        var items = [Item]()
                        for doc in snap.documents {
                            let newItem = Item(document: doc)
                            items.append(newItem)
                        }
                        
                        categoryItems[subcat] = items
                        
                        group.leave()
                    })
            }
            
            group.wait()
            
            results(nil, categoryItems)
        }
        
    }
}
