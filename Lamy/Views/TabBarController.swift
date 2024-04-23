//
//  TabBarController.swift
//  Lamy
//
//  Created by Nur on 4/7/24.
//

import UIKit
import SwiftUI

class TabBarController: UITabBarController {
    
    private let searchViewController = SearchViewController()
    private let library = PlaylistViewController()
    private var minimizedConstrain: NSLayoutConstraint!
    private var maximizedConstrain: NSLayoutConstraint!
    private var bottomConstrain: NSLayoutConstraint!
    private let playerView = Bundle.main.loadNibNamed("PlayerView",
                                                    owner: TabBarController.self,
                                                    options: nil)?.first as! PlayerView

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupPlayer()
    }
    
    private func setupView() {
        let playlist = PlaylistSwiftUIView()
        let hostView = UIHostingController(rootView: playlist)
        let navigatoinForSearch = UINavigationController(rootViewController: searchViewController)
        let navigatoinForLibrary = UINavigationController(rootViewController: hostView)
        
        view.backgroundColor = .white
        view.tintColor = .darkGray
        tabBar.backgroundColor = .white
        navigatoinForSearch.navigationBar.backgroundColor = .white
        
        navigatoinForSearch.visibleViewController?.title = "Find"
        let leftImage = UIImage(systemName: "magnifyingglass.circle.fill")
        navigatoinForSearch.tabBarItem.image = leftImage
        navigatoinForSearch.tabBarItem.title = "Find"
        navigatoinForSearch.navigationBar.prefersLargeTitles = true
        navigatoinForLibrary.visibleViewController?.title = "Playlist"
        let rightImage = UIImage(systemName: "play.circle.fill")
        navigatoinForLibrary.tabBarItem.image = rightImage
        navigatoinForLibrary.tabBarItem.title = "Playlist"
        navigatoinForLibrary.navigationBar.prefersLargeTitles = true
        let image = UIImage(systemName: "headphones.circle.fill")
        let imageView = UIImageView(image: image)
        let screenSize = UIScreen.main.bounds
        imageView.frame = CGRect(x: 0 ,
                                 y: (screenSize.midY + 100) / 2,
                                 width: screenSize.width,
                                 height: screenSize.width)
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.tintColor = .gray.withAlphaComponent(0.05)
        
        viewControllers = [ navigatoinForSearch, navigatoinForLibrary ]
        view.insertSubview(imageView, belowSubview: tabBar)
        view.insertSubview(playerView, belowSubview: tabBar)
    }
    
    private func setupPlayer() {
        playerView.playerControlDelegate = self
        playerView.delegate = searchViewController
        searchViewController.tabBarDelegate = self
        playerView.translatesAutoresizingMaskIntoConstraints = false
        maximizedConstrain = playerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedConstrain = playerView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -70)
        bottomConstrain = playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        maximizedConstrain.isActive = true
        bottomConstrain.isActive = true
    }
}

extension TabBarController: PlayerViewControlProtocol {
    func minimizePlayerView() {
        self.tabBar.transform = CGAffineTransform(scaleX: 1, y: 1)
        playerView.miniView.isHidden = false
        playerView.maxView.isHidden = true
        maximizedConstrain.isActive = false
        minimizedConstrain.isActive = true
        bottomConstrain.constant = view.frame.height
        UIView.animate(withDuration: 0.2,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveLinear,
                           animations: {
                self.view.layoutIfNeeded()
            },
                           completion: nil)
        }
        
    
    func maximizePlayerView(play track: Track?) {
        self.tabBar.transform = CGAffineTransform(scaleX: 0, y: 0.01)
        playerView.miniView.isHidden = true
        playerView.maxView.isHidden = false
        let searchHight = searchViewController.searchController.searchBar.frame.height * 2
        maximizedConstrain.constant = searchHight
        minimizedConstrain.isActive = false
        maximizedConstrain.isActive = true
        bottomConstrain.constant = 0
        UIView.animate(withDuration: 0.2,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveLinear,
                           animations: {
                self.view.layoutIfNeeded()
            },
                           completion: nil)
        guard let track = track else { return }
        playerView.setupView(with: track)
        
    }
}
