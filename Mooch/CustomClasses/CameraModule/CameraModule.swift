////
//  CameraModule.swift
//  Mooch
//
//  Created by App Center on 5/5/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit
import ImagePicker

protocol CameraModuleDelegate {
    func camera(_ camera: CameraModule, didFinishWithImages images: [UIImage])
}

class CameraModule: NSObject {

    var cameraDelegate: CameraModuleDelegate?
    let picker: ImagePickerController = {
        let config = Configuration()
        config.allowMultiplePhotoSelection = true
        config.allowPinchToZoom = true
        config.allowVideoSelection = false
        config.allowVolumeButtonsToTakePicture = true
        
        let picker = ImagePickerController(configuration: config)
        picker.imageLimit = 5
        picker.startOnFrontCamera = false
        
        return picker
    }()
    
    func start() {
        picker.delegate = self
    }
    
    func proceedWithPhotos(images: [UIImage]) {
        cameraDelegate?.camera(self, didFinishWithImages: images)
    }

}

extension CameraModule: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("Wrapper")
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("Done")
        imagePicker.dismiss(animated: true, completion: nil)
        proceedWithPhotos(images: images)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        print("Cancel")
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
