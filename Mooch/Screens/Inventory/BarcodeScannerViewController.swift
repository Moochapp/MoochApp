////
//  BarcodeScannerViewController.swift
//  Mooch
//
//  Created by App Center on 5/5/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit
import AVFoundation
import LDLogger

class BarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var coordinator: MainCoordinator!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
    
    func found(code: String) {
        let base = "https://api.upcitemdb.com/prod/trial/lookup?upc="
        let urlString = "\(base)\(code)"
        let network = Network(urlString: urlString)
        network.startTask { (data) in
            if let data = data {
                if let item = self.parse(json: data) {
                    DispatchQueue.main.async {
                        self.coordinator.selectImagesFromAPI(item: item)
                    }
                } else {
                    Log.d("Couldn't find any data for item.")
                    DispatchQueue.main.async {
                        self.showMessage(title: "Hmmm...", desc: "Couldn't find data for UPC code", success: false)
                        self.captureSession.startRunning()
                    }
                }
            } else {
                Log.d("Couldn't get data for item.")
                DispatchQueue.main.async {
                    self.showMessage(title: "Hmmm...", desc: "Couldn't find data for UPC code", success: false)
                    self.captureSession.startRunning()
                }
            }
        }
    }
    
    func showMessage(title: String, desc: String, success: Bool) {
        let em = EntryManager(viewController: self)
        em.showNotificationMessage(attributes: em.bottomToast, title: title, desc: desc, textColor: .white, imageName: nil, backgroundColor: EKColor.Mooch.darkGray, haptic: success ? .success : .error)
    }
    
    func parse(json: Data) -> UPCItem? {
        let decoder = JSONDecoder()
        do {
            if let results = try? decoder.decode(UPCResults.self, from: json) {
                var items = results.items
                if items.count > 0 {
                    return items.first!
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } catch {
            Log.e(error.localizedDescription)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}
