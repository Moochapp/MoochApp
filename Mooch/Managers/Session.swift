////
//  Session.swift
//  Mooch
//
//  Created by Luke Davis on 01/26/2019.
//  Copyright © 2019 rlukedavis. All rights reserved.
//

import Foundation
import FirebaseAuth
import LDLogger

class Session {
    static var shared = Session()
    public var moocher: Moocher!
    public var currentDeviceToken: String?
    public var cache = SessionCache()
    
    typealias ItemCompletion = ([Item])->()
    public func updateDataForCurrentUser(completion: ItemCompletion?) {
    DispatchQueue.global(qos: .userInitiated).async {
        let query = FirebaseManager.items.whereField("Owner", isEqualTo: self.moocher.id)
        query.getDocuments(completion: { (snap, error) in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            guard let snap = snap else { return }
            
            var items: [Item] = []
            for item in snap.documents {
                items.append(Item(document: item))
            }
            
            self.moocher.items = items
            completion?(items)
        })
    }
}
    
    
}

class SessionCache {
    private var imageCache = NSCache<NSString, NSData>()
    
    enum ImageCacheError: Error {
        case noImageData
        case noImageForID
        case failedImageFromData
    }
    
    public func addToCache(image: UIImage, itemID: String, imageID: String) throws {
        let name = "\(itemID)-\(imageID)"
        guard let data = image.toData() else {
            throw ImageCacheError.noImageData
        }
        
        imageCache.setObject(data.toNSData(), forKey: name.toNSString())
        Log.i("Image was cached: \(name)")
    }
    
    public func getImageFrom(itemID: String, imageID: String) throws -> UIImage {
        let name = "\(itemID)-\(imageID)"
        guard let nsdata = imageCache.object(forKey: name.toNSString()) else {
            throw ImageCacheError.noImageForID
        }
        
        let data = Data(nsdata)
        
        guard let image = data.getImage() else {
            throw ImageCacheError.failedImageFromData
        }
        
        return image
    }
}
