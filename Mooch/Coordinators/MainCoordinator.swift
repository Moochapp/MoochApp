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
        nav1.navigationBar.tintColor = #colorLiteral(red: 0.01112855412, green: 0.7845740914, blue: 0.9864193797, alpha: 1)
        nav1.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        let search = SearchViewController.instantiate(from: "Search")
        search.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        nav1.viewControllers = [search]
        
        let nav2 = UINavigationController()
        nav2.navigationBar.tintColor = #colorLiteral(red: 0.01112855412, green: 0.7845740914, blue: 0.9864193797, alpha: 1)
        nav2.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        let mooch = SocialViewController.instantiate(from: "Social")
        mooch.coordinator = self
        mooch.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        nav2.viewControllers = [mooch]
        
        let nav3 = UINavigationController()
        nav3.navigationBar.tintColor = #colorLiteral(red: 0.01112855412, green: 0.7845740914, blue: 0.9864193797, alpha: 1)
        nav3.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        let profile = ProfileViewController.instantiate(from: "Profile")
        profile.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
        profile.coordinator = self
        nav3.viewControllers = [profile]
        
        let nav4 = UINavigationController()
        nav4.navigationBar.tintColor = #colorLiteral(red: 0.01112855412, green: 0.7845740914, blue: 0.9864193797, alpha: 1)
        nav4.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        let explore = ExploreViewController.instantiate(from: "MainApp")
        explore.coordinator = self
        explore.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 3)
        explore.tabBarItem.title = "Explore"
        nav4.viewControllers = [explore]
        
        let nav5 = UINavigationController()
        nav5.navigationBar.tintColor = #colorLiteral(red: 0.01112855412, green: 0.7845740914, blue: 0.9864193797, alpha: 1)
        nav5.navigationBar.backgroundColor = #colorLiteral(red: 0.01112855412, green: 0.7845740914, blue: 0.9864193797, alpha: 1)
        nav5.navigationBar.isTranslucent = false
        nav5.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        let inventory = InventoryViewController.instantiate(from: "MainApp")
        inventory.coordinator = self
        inventory.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 4)
        inventory.tabBarItem.title = "Inventory"
        nav5.viewControllers = [inventory]
        
        tabbar.viewControllers = [mooch, explore, inventory, profile]
        navigationController.isNavigationBarHidden = false
        navigationController.pushViewController(tabbar, animated: true)
    }
    
    func showSubCategories(with category: String, image: UIImage) {
        let vc = SubcategoryViewController()
        vc.coordinator = self
        vc.category = category
        navigationController.isNavigationBarHidden = false
        navigationController.pushViewController(vc, animated: true)
    }
    
    func chooseCreateMethod() {
        let vc = ChooseMethodViewController.instantiate(from: "MainApp")
        vc.coordinator = self
        navigationController.isNavigationBarHidden = false
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showItemDetail(with images: [UIImage]) {
        let vc = ItemDetailViewController()
        vc.item = Item()
        vc.item.images = images
        navigationController.isNavigationBarHidden = false
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showItemDetail(for item: Item) {
        let vc = ItemDetailViewController()
        vc.item = item
    }
    
    func finish() {
        navigationController.popToRootViewController(animated: true)
    }
    
}
