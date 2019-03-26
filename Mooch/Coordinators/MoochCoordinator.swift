////
//  MoochCoordinator.swift
//  MoochApp
//
//  Created by App Center on 12/28/18.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import UIKit

class MoochCoordinator {
    var childCoordinators: [Coordinator] = []
    var mainCoordinator: MainCoordinator
    var tabbarController: UITabBarController
    
    init(mainCoord: MainCoordinator, tabbar: UITabBarController) {
        self.mainCoordinator = mainCoord
        self.tabbarController = tabbar
    }
    
    func start() {
        
        
    }
    
    
}
