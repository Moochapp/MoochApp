////
//  FadedImageView.swift
//  Mooch
//
//  Created by App Center on 4/29/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit

class FadedImageView: UIImageView {
    
    var fade = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    override init(image: UIImage?) {
        super.init(image: image)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        fade.backgroundColor = .black
        fade.clipsToBounds = true
        fade.layer.cornerRadius = 5
        fade.alpha = 0.25
        self.addSubview(fade)
        fade.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
