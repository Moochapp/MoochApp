////
//  ProfilePicture.swift
//  Mooch
//
//  Created by App Center on 3/31/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit

protocol ProfilePictureDelegate {
    func didSelectProfilePicture()
}

class ProfilePicture: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    private func initialize() {
        Bundle.main.loadNibNamed("Checkbox", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.button.setTitle("", for: .normal)
    }

    var delegate: ProfilePictureDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    @IBAction func didPressButton(_ sender: UIButton) {
        delegate?.didSelectProfilePicture()
    }
    
}
