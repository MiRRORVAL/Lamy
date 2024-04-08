//
//  TabBarController.swift
//  Lamy
//
//  Created by Nur on 4/7/24.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.tintColor = .green
    
        let searchViewController = SearchViewController()
        let library = ViewController()
        
        let navigatoinForSearch = UINavigationController(rootViewController: searchViewController)
        let navigatoinForLibrary = UINavigationController(rootViewController: library)
        
        navigatoinForSearch.visibleViewController?.title = "Find"
        navigatoinForSearch.tabBarItem.image = .add
        navigatoinForSearch.tabBarItem.title = "Find"
        navigatoinForSearch.navigationBar.prefersLargeTitles = true
        
        navigatoinForLibrary.visibleViewController?.title = "Playlists"
        navigatoinForLibrary.tabBarItem.image = .checkmark
        navigatoinForLibrary.tabBarItem.title = "Playlists"
        navigatoinForLibrary.navigationBar.prefersLargeTitles = true
        
        
        viewControllers = [ navigatoinForSearch, navigatoinForLibrary ]
    }
     
    
    
    
    
    
    
    
}
