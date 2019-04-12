////
//  ItemDetailsView.swift
//  Mooch
//
//  Created by App Center on 4/10/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit

class ItemDetailsView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak private var category: UILabel!
    @IBOutlet weak private var itemName: UILabel!
    
    @IBOutlet weak private var ownerName: UILabel!
    
    @IBOutlet weak private var moochLbl: UILabel!
    @IBOutlet weak private var rentLbl: UILabel!
    @IBOutlet weak private var purchaseLbl: UILabel!
    
    @IBOutlet weak private var availableLbl: UILabel!
    @IBOutlet weak private var inUseLbl: UILabel!
    
    @IBOutlet weak private var numberMoochualFriends: UILabel!
    
    @IBOutlet weak private var numberOfLikes: UILabel!
    
    public var item: Item
    
    override init(frame: CGRect) {
        self.item = Item()
        super.init(frame: frame)
        commonInit()
    }
    
    init(item: Item, frame: CGRect) {
        self.item = item
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.item = Item()
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ItemDetailsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.cornerRadius = 5
        
        category.text = item.category
        itemName.text = item.name
        Moocher.nameFrom(id: item.owner, completion: { [weak self] (name) in
            self?.ownerName.text = name ?? ""
        })
        
        for avail in item.availableFor {
            switch avail.key {
            case .mooch:
                if avail.value {
                    moochLbl.textColor = EKColor.Mooch.lightBlue
                }
            case .buy:
                if avail.value {
                    purchaseLbl.textColor = EKColor.Mooch.lightBlue
                }
            case .rent:
                if avail.value {
                    rentLbl.textColor = EKColor.Mooch.lightBlue
                }
            }
        }
        if item.status == .available {
            availableLbl.textColor = EKColor.Mooch.lightBlue
        } else {
            inUseLbl.textColor = EKColor.Mooch.lightBlue
        }
        
        numberOfLikes.text = "\(item.likes)"
        
    }
    
}
