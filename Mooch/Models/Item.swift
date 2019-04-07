////
//  Item.swift
//
//  Created by App Center on 12/28/18.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Item {
    var id: String
    var timestamp: TimeInterval
    var name: String
    var category: String
    var subcategory: String
    var owner: String
    var images: [UIImage] = []
    var imageRefs: [String] = []
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
        self.timestamp = Date().timeIntervalSince1970
        self.name = ""
        self.category = ""
        self.subcategory = ""
        self.owner = ""
        self.images = []
    }
    
    public convenience init(document: DocumentSnapshot) {
        self.init()
        if let itemData = document.data() {
            print(itemData)
            self.id = itemData["ID"] as! String
            self.timestamp = itemData["Timestamp"] as? Double ?? 0.0
            self.name = itemData["Name"] as! String
            self.category = itemData["Category"] as! String
            self.subcategory = itemData["Subcategory"] as! String
            self.owner = itemData["Owner"] as! String
            self.imageRefs = itemData["ImageRefs"] as? [String] ?? []
            self.rentalFee = itemData["RentalFee"] as? Double
            self.rentalInterval = itemData["RentalInterval"] as? String
            self.price = itemData["Price"] as? Double
            self.likes = itemData["Likes"] as! Int
            
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
        let data = toDictionary()
        DispatchQueue.global(qos: .userInitiated).async {
            var errors: [Int: Error?] = [:]
            let uploadGroup = DispatchGroup()
            
            for (index, image) in self.images.enumerated() {
                uploadGroup.enter()
                
                let name = "img-\(index)"
                
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
    
    private func toDictionary() -> [String: Any] {
        
        let availFor = [Availability.buy.rawValue: availableFor[.buy]!,
                        Availability.rent.rawValue: availableFor[.rent]!,
                        Availability.mooch.rawValue: availableFor[.mooch]!]
        
        let data: [String : Any] = ["ID": self.id,
        "Name": self.name,
        "Category": self.category,
        "Subcategory": self.subcategory,
        "Owner": self.owner,
        "ImageRefs": self.imageRefs,
        "AvailableFor": availFor,
        "RentalFee": self.rentalFee as Any,
        "RentalInterval": self.rentalInterval as Any,
        "Price": self.price as Any,
        "Status": self.status.rawValue,
        "Likes": self.likes]
        
        return data
    }
    
    private func uploadImage(itemID: String, name: String, image: UIImage, progress: @escaping (Double)->(), completion: @escaping (Error?)->()) {
        let data = image.pngData()!
        let ref = FirebaseManager.storage.reference().child("Items").child(itemID).child(name)
        let task = ref.putData(data, metadata: nil) { (metadata, error) in
            guard error == nil else {
                completion(error) // Error on upload
                return
            }
            ref.downloadURL(completion: { (url, error) in
                guard error == nil else {
                    completion(error) // Error on path download
                    return
                }
                FirebaseManager.items.document(itemID).updateData(["ImageRefs": FieldValue.arrayUnion([url?.absoluteString])])
                completion(nil) // all went as planned
            })
        }
        task.observe(.progress) { (snapshot) in
            if let completed = snapshot.progress?.fractionCompleted {
                progress(completed)
            }
        }
    }
    
}
