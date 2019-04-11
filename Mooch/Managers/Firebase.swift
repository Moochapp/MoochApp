////
//  Firebase.swift
//  Mooch
//
//  Created by Luke Davis on 01/26/2019.
//  Copyright © 2019 rlukedavis. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseManager {
    public static var db = Firestore.firestore()
    public static var auth = Auth.auth()
    public static var storage = Storage.storage()
    
    public static var users = db.collection("Users")
    public static var items = db.collection("Items")
       
}
