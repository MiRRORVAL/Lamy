//
//  DataManager.swift
//  Lamy
//
//  Created by Nur on 4/8/24.
//

import Alamofire
import Foundation

final class DataManager {
    
    static let shared = DataManager()
    
    private let baseUrl = "https://itunes.apple.com/search?term="
    private var country = "&country=RU"
    private var entity = "&entity=song"
    private var limit = "&limit=50"
    
    var musicTracks: [ReceivedSearchItems] = []
    var playlisTracks: [Track] = []
    
    func fetchData(for searchRequest: String, complitionHandler: @escaping () -> ()) {
        guard searchRequest != "" else {
            musicTracks.removeAll()
            complitionHandler()
            return
        }
        let fullUrl = baseUrl + searchRequest + entity + country
        AF.request(fullUrl).response { response in
            if let error = response.error {
                print(error.localizedDescription)
            }
            else {
                guard let data = response.data else { return }
                let decoder = JSONDecoder()
                do {
                    let dedcodedData = try decoder.decode(ReceivedSearchResult.self, from: data)
                    guard dedcodedData.resultCount != 0 else { return }
                    self.musicTracks = dedcodedData.results
                    complitionHandler()
                } catch let decodeError {
                    print(decodeError)
                }
            }
        }
    }
    
    func saveTrack(_ track: Track) {
        playlisTracks.append(track)
        guard !playlisTracks.isEmpty else { return }
        guard let encoded = try? JSONEncoder().encode(playlisTracks) else { return }
        UserDefaults.standard.set(encoded, forKey: "savedTracks")
        print("Saved")
    }
    
    func loadTracks() -> [Track]? {
        guard let loadedEncodedTracks = UserDefaults.standard.object(forKey: "savedTracks") as? Data else { return nil}
        guard let loadedTracks = try? JSONDecoder().decode([Track].self, from: loadedEncodedTracks) else { return nil}
        playlisTracks = loadedTracks
        return loadedTracks
    }
    
}

