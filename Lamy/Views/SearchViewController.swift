//
//  SearchViewController.swift
//  Lamy
//
//  Created by Nur on 4/8/24.
//

import UIKit

class SearchViewController: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)
    weak var tabBarDelegate: PlayerViewControlProtocol?
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
        let trackForCell = Track(artistName: dataManager.musicTracks[indexPath.row].artistName, collectionName: dataManager.musicTracks[indexPath.row].collectionName, trackName: dataManager.musicTracks[indexPath.row].trackName, artworkUrl100: dataManager.musicTracks[indexPath.row].artworkUrl100, previewUrl: nil)
        cell.setCell(vith: trackForCell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.text = "Looking for romething?"
        lable.textColor = .lightGray
        lable.font = .italicSystemFont(ofSize: 20)
        return lable
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let result: CGFloat = !dataManager.musicTracks.isEmpty ? 0 : 30
        return result
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = makeTrack(nextIndexPath: indexPath)
        tabBarDelegate?.setPlayerViewDelegate(asPlaylist: false)
        tabBarDelegate?.maximizePlayerView(play: track)
    }
    
    func makeTrack(nextIndexPath: IndexPath) -> Track {
        let track = Track(artistName: dataManager.musicTracks[nextIndexPath.row].artistName, collectionName: dataManager.musicTracks[nextIndexPath.row].collectionName,
                          trackName: dataManager.musicTracks[nextIndexPath.row].trackName,
                          artworkUrl100: dataManager.musicTracks[nextIndexPath.row].artworkUrl100, previewUrl: dataManager.musicTracks[nextIndexPath.row].previewUrl)
        return track
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.placeholder = "Let's find"
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        let color = UIColor(red: 0.2, green: 0.6, blue: 0.7, alpha: 0.5)
        view.tintColor = color
    }
}

