////
//  ItemDetailViewController.swift
//  Mooch
//
//  Created by App Center on 3/27/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {

    var coordinator: MainCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var item: Item!
    
    
    

}

class ItemDetailTableViewManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    init(coordinator: MainCoordinator, viewController: ItemDetailViewController, dataSource: [String]) {
        self.coordinator = coordinator
        self.viewController = viewController
        self.dataSource = dataSource
    }
    
    weak var coordinator: MainCoordinator!
    weak var viewController: ItemDetailViewController!
    let cellDescriptions = ["ImageAreaSectionCell", "DetailsSectionCell", "SimilarItemsCell", "MoreItemsCell"]
    var item: Item
    var dataSource: [String] = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            // Configure cell 1
            let cell = tableView.dequeueReusableCell(withIdentifier: cellDescriptions[indexPath.row], for: indexPath)
            
            let bg = UIImageView(image: <#T##UIImage?#>)
            
            return cell
        } else if section == 1 {
            // Configure cell 2
            
        } else if section == 2 {
            // Configure cell 3
            
        } else if section == 3 {
            // Configure cell 4
            
        }
    }
    
}
