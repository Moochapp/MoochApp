////
//  ImagePreviewer.swift
//  Mooch
//
//  Created by App Center on 3/29/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit

class ImagePreviewer: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var container: UIView!
    
    
    func configure(in parent: UIView) {
        parent.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(parent.safeAreaLayoutGuide.snp.edges)
        }
        
        container = UIView(frame: .zero)
        container.backgroundColor = .red
        addSubview(container)
        container.snp.makeConstraints { (make) in
            make.width.equalTo(self.frame.width - 16)
            make.height.equalTo(self.frame.width - 16)
            make.center.equalToSuperview()
        }
        
    }
    

}
