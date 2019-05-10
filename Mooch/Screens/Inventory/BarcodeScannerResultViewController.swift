////
//  BarcodeScannerResultViewController.swift
//  Mooch
//
//  Created by App Center on 5/5/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class BarcodeScannerResultViewController: UIViewController {

    // Admin
    var coordinator: MainCoordinator!
    
    // Properties
    var item: UPCItem!
    var images: [UIImage] = []
    var selected: [Int: Bool] = [:]
    var selectedImages: [Int: UIImage?] = [:]
    let titleLabel: UnderlinedLabel = {
        let lbl = UnderlinedLabel(frame: .zero)
        lbl.textColor = EKColor.Mooch.darkGray
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "Avenir", size: 24)
        
        return lbl
    }()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        
        return collection
    }()
    lazy var cameraModule: CameraModule = {
        let cm = CameraModule()
        cm.start()
        return cm
    }()
    
    // Reference
    let BarcodeResultImageCellID = "BarcodeResultImageCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done(sender:)))
        titleLabel.text = item.title
        placeViews()
        downloadImages()
        
    }
    
    func placeViews() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
    }
    func configureCollection() {
        collectionView.register(BarcodeResultImageCell.self, forCellWithReuseIdentifier: BarcodeResultImageCellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
    }
    func downloadImages() {
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInitiated).async {
            for url in self.item.images {
                group.enter()
                let network = Network(urlString: url)
                network.startTask { (data) in
                    if let data = data {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.images.append(image)
                            }
                        }
                        group.leave()
                    } else {
                        print("Error")
                        group.leave()
                    }
                }
            }
            group.wait()
            
            DispatchQueue.main.async {
                self.configureCollection()
            }
        }
    }
    func askForAdditionalImages(title: String, desc: String, currentImages: [UIImage], newImageCap: Int) {
        let em = EntryManager(viewController: self)
        em.showAlertView(title: title, desc: desc, attributes: em.centerAlert, affirmTitle: "Yes!", affirmAction: {
            self.cameraModule.cameraDelegate = self
            self.cameraModule.picker.imageLimit = newImageCap
            self.present(self.cameraModule.picker, animated: true, completion: nil)
        }, cancelTitle: "No thanks!") {
            self.coordinator.createItem(with: self.finalImages, upcItem: self.item)
//            self.cameraModule.cameraDelegate = self
//            self.cameraModule.picker.imageLimit = newImageCap
//            self.present(self.cameraModule.picker, animated: true, completion: nil)
        }
    }
    
    var finalImages: [UIImage] = []
    @objc func done(sender: UIBarButtonItem) {
        sender.isEnabled = false
        for image in selectedImages {
            if let img = image.value {
                finalImages.append(img)
            }
        }
        if finalImages.count == 0 {
            self.cameraModule.cameraDelegate = self
            self.cameraModule.picker.imageLimit = 5
            self.present(self.cameraModule.picker, animated: true, completion: nil)
        } else {
            let count = 5 - finalImages.count
            if count > 0 {
                askForAdditionalImages(title: "Great! Would you like to add some photos from your device? ",
                                       desc: "You can add \(count) more photos to your item!",
                                       currentImages: finalImages, newImageCap: count)
            } else {
                self.coordinator.createItem(with: finalImages, upcItem: self.item)
            }
        }
        sender.isEnabled = true
    }
    
}

// MARK: - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
extension BarcodeScannerResultViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = "No Images here!"
        let attr = NSAttributedString(string: title)
        return attr
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let desc = "Looks like we couldn't find any images for the code you scanned. Press 'Done' to add images from your devices camera."
        let attr = NSAttributedString(string: desc)
        return attr
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension BarcodeScannerResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BarcodeResultImageCellID, for: indexPath) as! BarcodeResultImageCell
        
        cell.commonInit()
        cell.imageView.image = self.images[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let count = selected.filter { (item) -> Bool in
            return item.value
        }.count
        if let isSelected = selected[indexPath.row] {
            if isSelected {
                selected[indexPath.row] = false
                selectedImages[indexPath.row] = nil
                // make smaller
                collectionView.reloadData()
            } else {
                if count < 5 {
                    selected[indexPath.row] = true
                    selectedImages[indexPath.row] = images[indexPath.row]
                    // make bigger
                    collectionView.reloadData()
                }
            }
        } else {
            if count < 5 {
                selected[indexPath.row] = true
                selectedImages[indexPath.row] = images[indexPath.row]
                // make bigger
                collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cWidth = collectionView.frame.width
        
        let items = CGFloat(3.5)
        let spacing = CGFloat(8.0)
        
        if let isSelected = selected[indexPath.row] {
            if isSelected {
                let width = ((cWidth - ((items - 1) * spacing)) / items) + 20
                return CGSize(width: width, height: width)
            } else {
                let width = ((cWidth - ((items - 1) * spacing)) / items) - 10
                return CGSize(width: width, height: width)
            }
        } else {
            let width = ((cWidth - ((items - 1) * spacing)) / items) - 10
            return CGSize(width: width, height: width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}

// MARK: - CameraModuleDelegate
extension BarcodeScannerResultViewController: CameraModuleDelegate {
    func camera(_ camera: CameraModule, didFinishWithImages images: [UIImage]) {
        self.finalImages.append(contentsOf: images)
        self.coordinator.createItem(with: finalImages, upcItem: self.item)
    }
}

// MARK: - Barcode Result Cell
class BarcodeResultImageCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    let fader: UIView = {
        let fader = UIView()
        fader.alpha = 0.25
        fader.backgroundColor = .black
        fader.clipsToBounds = true
        fader.layer.cornerRadius = 5
        
        return fader
    }()
    
    func commonInit() {
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.addSubview(fader)
        fader.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}


class UnderlinedLabel: UILabel {
    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSMakeRange(0, text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
            self.attributedText = attributedText
        }
    }
}
