////
//  ChooseMethodViewController.swift
//  Mooch
//
//  Created by App Center on 3/29/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit
import ImagePicker

class ChooseMethodViewController: UIViewController, Storyboarded {

    var coordinator: MainCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        
    }
    
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var chooseFromLibraryButton: UIButton!
    @IBOutlet weak var scanBarcodeButton: UIButton!
    
    @IBAction func takePhoto(_ sender: UIButton) {
        let config = Configuration()
        config.allowMultiplePhotoSelection = true
        config.allowPinchToZoom = true
        config.allowVideoSelection = false
        config.allowVolumeButtonsToTakePicture = true
        let picker = ImagePickerController(configuration: config)
        picker.imageLimit = 5
        picker.delegate = self
        picker.startOnFrontCamera = false
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func chooseFromLibrary(_ sender: UIButton) {
        print("Library")
        let photographer = Photographer(viewController: self, type: .photoLibrary)
        self.present(photographer.camera, animated: true, completion: nil)
    }
    
    @IBAction func scanBarcode(_ sender: UIButton) {
        print("Scan")
    }
    
    func proceedWithPhotos(images: [UIImage]) {
        print("proceeding with \(images.count) photos")
        coordinator.showItemDetail(with: images)
    }
    
}

extension ChooseMethodViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.editedImage] as? UIImage {
            proceedWithPhotos(images: [image])
        } else if let image = info[.originalImage] as? UIImage {
            proceedWithPhotos(images: [image])
        }
        
    }
}

extension ChooseMethodViewController: ImagePickerDelegate {
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
