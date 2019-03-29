////
//  Photographer.swift
//  Mooch
//
//  Created by App Center on 3/29/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import UIKit

class Photographer {
    init(viewController: UIViewController, type: UIImagePickerController.SourceType) {
        camera.sourceType = type
        camera.allowsEditing = true
        camera.delegate = viewController as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
    }
    
    var camera = UIImagePickerController()
    
}
