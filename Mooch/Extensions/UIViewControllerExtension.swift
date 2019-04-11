////
//  UIViewControllerExtension.swift
//  Mooch
//
//  Created by App Center on 2/21/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// Adds a child viewController to the subview
    ///
    /// - Parameter child: a child viewController
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    /// Removes a child viewController from it's parent
    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
 
    func showProgressIndicator(completion: (UIActivityIndicatorView)->()) {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = EKColor.Mooch.lightBlue
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        completion(indicator)
    }
    
}
