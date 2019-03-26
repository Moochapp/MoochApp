////
//  FirebaseUserManager.swift
//  HealthApp
//
//  Created by App Center on 12/28/18.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation

protocol FirebaseUser {
    func syncChanges(result: @escaping (Error?)->())
    func syncToLocal(result: @escaping (Error?)->())
}
