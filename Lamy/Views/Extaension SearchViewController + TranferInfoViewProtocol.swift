//
//  Extaension SearchViewController + TranferInfoViewProtocol.swift
//  Lamy
//
//  Created by mix on 18.4.24..
//

import Foundation

extension SearchViewController: TransferInfoToPlayerViewProtocol {
    
    
    private func moveTableViewPointer(nextIndexPath: IndexPath) {
        tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
        tableView.selectRow(at: nextIndexPath, animated: false, scrollPosition: .none)
    }
    
    private func makeTrack(nextIndexPath: IndexPath) -> Track {
        let track = Track(artistName: dataManager.musicTracks[nextIndexPath.row].artistName, collectionName: dataManager.musicTracks[nextIndexPath.row].collectionName,
                          trackName: dataManager.musicTracks[nextIndexPath.row].trackName,
                          artworkUrl100: dataManager.musicTracks[nextIndexPath.row].artworkUrl100, previewUrl: dataManager.musicTracks[nextIndexPath.row].previewUrl)
        return track
    }
    
    func moveBack() -> Track? {
        guard let actualIndexPath = tableView.indexPathForSelectedRow else { return nil }
        let count = dataManager.musicTracks.count - 1
        let nextRow = actualIndexPath.row - 1 < 0 ? count : actualIndexPath.row - 1
        let nextIndexPath = IndexPath(row: nextRow, section: 0)
        moveTableViewPointer(nextIndexPath: nextIndexPath)
        let track = makeTrack(nextIndexPath: nextIndexPath)
        return track
    }
    
    func moveForward() -> Track? {
        guard let actualIndexPath = tableView.indexPathForSelectedRow else { return nil }
        let count = dataManager.musicTracks.count - 1
        let nextRow = actualIndexPath.row + 1 > count ? 0 : actualIndexPath.row + 1
        let nextIndexPath = IndexPath(row: nextRow, section: 0)
        moveTableViewPointer(nextIndexPath: nextIndexPath)
        let track = makeTrack(nextIndexPath: nextIndexPath)
        return track
    }
}
