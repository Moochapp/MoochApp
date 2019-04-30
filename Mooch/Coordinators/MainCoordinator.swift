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
    
    func selectFavorites() {
        let pickFavorites = SelectFavoritesViewController()
        pickFavorites.coordinator = self
        navigationController.isNavigationBarHidden = false
        navigationController.navigationBar.barTintColor = #colorLiteral(red: 0.01112855412, green: 0.7845740914, blue: 0.9864193797, alpha: 1)
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController.pushViewController(pickFavorites, animated: true)
    }
    
    func mainApp() {
        
        let tabbar = UITabBarController()
        
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
//        nav5.navigationBar.backgroundColor = #colorLiteral(red: 0.01112855412, green: 0.7845740914, blue: 0.9864193797, alpha: 1)
        nav5.navigationBar.isTranslucent = false
        nav5.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        let inventory = InventoryViewController.instantiate(from: "MainApp")
        inventory.coordinator = self
        inventory.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 4)
        inventory.tabBarItem.title = "Inventory"
        nav5.viewControllers = [inventory]
        
//        let nav6 = UINavigationController()
//        let pickFavorites = SelectFavoritesViewController()
//        pickFavorites.coordinator = self
//        pickFavorites.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 5)
//        pickFavorites.tabBarItem.title = "test"
//        nav6.viewControllers = [pickFavorites]
        
        setupNavs(nav: nav3)
        setupNavs(nav: nav4)
        setupNavs(nav: nav5)
//        setupNavs(nav: nav6)
        
        tabbar.viewControllers = [nav5, nav4, nav3]
        tabbar.selectedIndex = 1
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
    
    func createItem(with item: Item) {
        
    }
    
    func createItem(with images: [UIImage]) {
        let vc = CreateItemViewController()
        vc.coordinator = self
        vc.item = Item()
        vc.item.images = images
        navigationController.isNavigationBarHidden = false
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showItemDetail(with images: [UIImage]) {
        let vc = ItemDetailTableViewController()
        vc.coordinator = self
        vc.item = Item()
        vc.item.images = images
        navigationController.isNavigationBarHidden = false
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showItemDetail(for item: Item) {
        let vc = ItemDetailTableViewController()
        vc.coordinator = self
        vc.item = item
        navigationController.isNavigationBarHidden = false
        navigationController.pushViewController(vc, animated: true)
    }
    
    func finish() {
        navigationController.popToRootViewController(animated: true)
    }
    
    

}

extension MainCoordinator {
    private func setupNavs(nav: UINavigationController) {
        nav.navigationBar.barTintColor = #colorLiteral(red: 0.01112855412, green: 0.7845740914, blue: 0.9864193797, alpha: 1)
        nav.navigationBar.tintColor = .white
        nav.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
}
