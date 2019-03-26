////
//  Firebase.swift
//  Mooch
//
//  Created by Luke Davis on 01/26/2019.
//  Copyright © 2019 rlukedavis. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    public static var db = Firestore.firestore()
    public static var auth = Auth.auth()
    
    public static var users = Firestore.firestore().collection("Users")
    public static var items = Firestore.firestore().collection("Items")
}
