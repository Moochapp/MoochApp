////
//  MoochersViewController.swift
//  Mooch
//
//  Created by App Center on 5/17/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import PromiseKit

class MoochersViewController: UIViewController {
    
    // Admin
    var coordinator: MainCoordinator!
    let MoocherCollectionViewCellID = "MoocherCollectionViewCellID"
    
    // Properties
    var collectionDataSource: [Friend] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSegmentedControl()
        getDataForCollectionView()
        
    }
    
    let segmentedControl: UISegmentedControl = {
        let titles = ["Moochual", "Contacts", "Nearby", "Groups"]
        
        let control = UISegmentedControl(items: titles)
        control.tintColor = EKColor.Mooch.lightBlue
        
        return control
    }()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 8.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        
        return collectionView
    }()

    
    // MARK: - Setups
    private func setupSegmentedControl() {
        self.segmentedControl.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview().inset(16)
        }
        segmentedControl.addTarget(self, action: #selector(didSelectSegment(sender:)), for: .valueChanged)
    }
    
    
    // MARK: - Class Methods
    private func getDataForCollectionView() {
        sync { (friends) in
            self.collectionDataSource = friends
            self.collectionView.reloadData()
        }
        
    }
    
    private func sync(compltion: ([Friend])->()) {
        
        Session.shared.moocher.syncToLocal { (error) in
            guard error == nil else {
                let em = EntryManager(viewController: self)
                em.showNotificationMessage(attributes: em.topToast,
                                           title: "Hmmm",
                                           desc: error!.localizedDescription,
                                           textColor: .white, imageName: nil,
                                           backgroundColor: EKColor.Mooch.darkGray, haptic: .error)
                return
            }
            
            // Do sorting here (probably)
            
        }
        
    }
    
    @objc private func didSelectSegment(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }
}

extension MoochersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let person = collectionDataSource[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoocherCollectionViewCellID, for: indexPath) as! MoocherCollectionViewCell
        
        cell.person = person
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension MoochersViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
}

class MoocherCollectionViewCell: UICollectionViewCell {
    var person: Friend
    
    init(person: Friend, frame: CGRect) {
        self.person = person
        switch person.status {
        case "Connected":
            actionButton = MoocherActionButton(style: .remove, frame: .zero)
        case "Requested":
            actionButton = MoocherActionButton(style: .requested, frame: .zero)
        case "Not Connected":
            actionButton = MoocherActionButton(style: .add, frame: .zero)
        default:
            fatalError()
        }
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func commonInit() {
        
    }
    
    let profilePictureView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let displayName: UILabel = {
        let label = UILabel(frame: .zero)
        
        return label
    }()
    
    var actionButton: MoocherActionButton
    
}

class MoocherActionButton: UIButton {
    typealias MoocherButtonAction = ()->()
    var style: MoocherActionButtonStyle
    var action: MoocherButtonAction?
    
    init(style: MoocherActionButtonStyle, frame: CGRect) {
        self.style = style
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        style = .add
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        layer.cornerRadius = 5
        setTitleColor(.white, for: .normal)
        
        switch style {
        case .add:
            backgroundColor = EKColor.Mooch.lightBlue
            setTitle("+ Add", for: .normal)
        case .requested:
            backgroundColor = EKColor.LightBlue.a700
            setTitle("Requested", for: .normal)
        case .remove:
            backgroundColor = EKColor.Gray.light
            setTitle("- Remove", for: .normal)
        }
    }
    
    @objc private func performAction() {
        action?()
    }
}

enum MoocherActionButtonStyle {
    case add, requested, remove
}

