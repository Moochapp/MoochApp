////
//  DateExtension.swift
//  Mooch
//
//  Created by App Center on 4/10/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Firebase

extension Date {
    func getFirebaseDate() -> Timestamp {
        return Timestamp(date: self)
    }
}
