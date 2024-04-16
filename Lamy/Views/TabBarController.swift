//
//  TabBarController.swift
//  Lamy
//
//  Created by Nur on 4/7/24.
//

import UIKit

class TabBarController: UITabBarController {
    
    var fullscreen = false {
        didSet {
            if true {
                
            }
        }
    }
    
    let playerViewWindow = Bundle.main.loadNibNamed("PlayerView",
                                                    owner: TabBarController.self,
                                                    options: nil)?.first as! PlayerView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarPlayerView()
        view.backgroundColor = .white
        view.tintColor = .green
        tabBar.backgroundColor = .white
        let searchViewController = SearchViewController()
        let library = ViewController()
        
        let navigatoinForSearch = UINavigationController(rootViewController: searchViewController)
        let navigatoinForLibrary = UINavigationController(rootViewController: library)
        
        navigatoinForSearch.navigationBar.backgroundColor = .white
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
    
    private func tabBarPlayerView() {
        view.insertSubview(playerViewWindow, belowSubview: tabBar)
        setFullScreenPlayer(nil)
        
    }
    
    private func setFullScreenPlayer(_ set: Bool?) {
        playerViewWindow.translatesAutoresizingMaskIntoConstraints = false
        
        if set == true {
            playerViewWindow.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            playerViewWindow.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        } else {
            playerViewWindow.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -70).isActive = true
            playerViewWindow.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        playerViewWindow.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerViewWindow.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        playerViewWindow.backgroundColor = .blue
        
        
        
        
    }
}
