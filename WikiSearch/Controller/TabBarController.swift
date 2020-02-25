//
//  TabBarController.swift
//  WikiSearch
//
//  Created by Ivan Fabri on 2/20/20.
//  Copyright © 2020 Ivan Fabri. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTabs()
    }
    
    func prepareTabs() {
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        let searchListViewController = ListViewController()
        searchListViewController.isItSearchController = true
        let savedListViewController = ListViewController()
        savedListViewController.isItSearchController = false
        
        self.viewControllers = [searchListViewController, savedListViewController]
        
        self.tabBar.items?[0].title = NSLocalizedString("SearchTitleText", comment: "")
        self.tabBar.items?[1].title = NSLocalizedString("SavedTitleText", comment: "")
        
        self.tabBar.unselectedItemTintColor = .white
        self.tabBar.barTintColor = .customBlue
        self.tabBar.tintColor = .customYeallow
    }
}
