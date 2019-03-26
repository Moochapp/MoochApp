////
//  MainCoordinator.swift
//  MoochApp
//
//  Created by App Center on 12/28/18.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(nav: UINavigationController) {
        self.navigationController = nav
    }
    
    func start() {
        let vc = LandingViewController.instantiate(from: "Landing")
        vc.coordinator = self
        vc.viewModel = LandingViewModel(coordinator: self)
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(vc, animated: false)
    }
    
    func onboarding() {
        let vc = OnboardingViewController.instantiate(from: "Onboarding")
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func signup() {
        let vc = SignUpViewController.instantiate(from: "LoginSignup")
        vc.coordinator = self
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func login() {
        let vc = LoginViewController.instantiate(from: "LoginSignup")
        vc.coordinator = self
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func mainApp() {
        let tabbar = UITabBarController()
        
        let nav1 = UINavigationController()
        let search = SearchViewController.instantiate(from: "Search")
        search.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        nav1.viewControllers = [search]
        
        let nav2 = UINavigationController()
        let mooch = SocialViewController.instantiate(from: "Social")
        mooch.coordinator = self
        mooch.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        nav2.viewControllers = [mooch]
        
        let nav3 = UINavigationController()
        let profile = ProfileViewController.instantiate(from: "Profile")
        profile.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
        profile.coordinator = self
        nav3.viewControllers = [profile]
        
        let nav4 = UINavigationController()
        let explore = ExploreViewController.instantiate(from: "MainApp")
        explore.coordinator = self
        explore.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 3)
        explore.tabBarItem.title = "Explore"
        nav4.viewControllers = [explore]
        
        let nav5 = UINavigationController()
        let inventory = InventoryViewController.instantiate(from: "MainApp")
        inventory.coordinator = self
        inventory.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 4)
        inventory.tabBarItem.title = "Inventory"
        
        tabbar.viewControllers = [nav2, nav4, nav3, inventory]
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(tabbar, animated: true)
    }
    
    func finish() {
        navigationController.popToRootViewController(animated: true)
    }
    
    
}
