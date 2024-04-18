//
//  SearchViewController.swift
//  Lamy
//
//  Created by Nur on 4/8/24.
//

import UIKit

class SearchViewController: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)
    
    var timer: Timer?
    let dataManager = DataManager.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        
        let nib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "reuseIdentifier")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.musicTracks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! SearchTableViewCell
        
        let track = Track(artistName: dataManager.musicTracks[indexPath.row].artistName, collectionName: dataManager.musicTracks[indexPath.row].collectionName, trackName: dataManager.musicTracks[indexPath.row].trackName, artworkUrl100: dataManager.musicTracks[indexPath.row].artworkUrl100, previewUrl: nil)
        
        cell.setCell(vith: track)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let color = UIColor(white: 0.5, alpha: 0.1)

        let image = UIImage(systemName: "headphones.circle.fill")
        let view = UIView()
        let imageView = UIImageView(image: image)
        let screenSize = UIScreen.main.bounds
        
        view.tintColor = .white
        view.backgroundColor = .white
        imageView.backgroundColor = color

        imageView.frame = CGRect(x: screenSize.width / 4 ,
                                 y: screenSize.width / 4,
                                 width: screenSize.width / 2,
                                 height: screenSize.width / 2)
        
        imageView.layer.cornerRadius = imageView.frame.height / 2
        view.addSubview(imageView)
        return (view)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        !dataManager.musicTracks.isEmpty ? 0 : 500
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.placeholder = "Insert song/artist name"
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let track = Track(artistName: dataManager.musicTracks[indexPath.row].artistName, collectionName: dataManager.musicTracks[indexPath.row].collectionName, 
                          trackName: dataManager.musicTracks[indexPath.row].trackName,
                          artworkUrl100: dataManager.musicTracks[indexPath.row].artworkUrl100, previewUrl: dataManager.musicTracks[indexPath.row].previewUrl)
        let window = UIApplication.shared.connectedScenes.compactMap {
            ($0 as? UIWindowScene)?.keyWindow
        }.last
        let playerViewWindow = Bundle.main.loadNibNamed("PlayerView",
                                                        owner: self,
                                                        options: nil)?.first as! PlayerView
        playerViewWindow.delegate = self
        playerViewWindow.setupView(with: track)
        
        window?.insertSubview(playerViewWindow, at: 1)
    }

}

