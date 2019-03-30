////
//  Checkbox.swift
//  Mooch
//
//  Created by App Center on 3/29/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit

protocol CheckBoxDelegate {
    func checkbox(checkbox: Checkbox, didChange checked: Bool)
}

class Checkbox: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("Checkbox", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        image.image = UIImage(named: "UnCheckBox")
    }

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var title: UILabel!
    
    var delegate: CheckBoxDelegate?
    var isChecked: Bool = false
    
    @IBAction func didChangeValue(_ sender: UIButton) {
        if isChecked {
            image.image = UIImage(named: "UnCheckBox")
            delegate?.checkbox(checkbox: self, didChange: false)
        } else {
            image.image = UIImage(named: "CheckBox")
            delegate?.checkbox(checkbox: self, didChange: true)
        }
        
        isChecked = !isChecked
    }
    
    public func setTitle(text: String) {
        title.text = text
    }
    
}
