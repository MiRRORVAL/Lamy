//
//  SearchViewController.swift
//  Lamy
//
//  Created by Nur on 4/8/24.
//

import UIKit

class SearchViewController: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)
    
    private var timer: Timer?
    let dataManager = DataManager.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataManager.musicTracks.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = "\(dataManager.musicTracks[indexPath.row].trackName) \n\(dataManager.musicTracks[indexPath.row].artistName)"
        cell.textLabel?.numberOfLines = 2
        let image = UIImage(systemName: "cube.transparent")
        cell.imageView?.image = image
        return cell
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchViewController: UISearchBarDelegate {
    
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_) in
                self.dataManager.fetchData(for: searchText) {
                    self.tableView.reloadData()
                }
            }
        }
    }
