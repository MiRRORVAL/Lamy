//
//  DataManager.swift
//  Lamy
//
//  Created by Nur on 4/8/24.
//

import Foundation
import Alamofire

final class DataManager {
    
    static let shared = DataManager()
    
    private let baseUrl = "https://itunes.apple.com/search?term="
    private var country = "&country=RU"
    private var entity = "&entity=song"
    private var limit = "&limit=25"
    
    var musicTracks: [ReceivedSearchItems] = []
    
    func fetchData(for searchRequest: String, complitionHandler: @escaping () -> ()) {
        let fullUrl = baseUrl + searchRequest + entity + country
        guard searchRequest != "" else { return }
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
    
    
    func fetchImage(from url: String) {
        
        
        
    }
    
    private init() {}
}

