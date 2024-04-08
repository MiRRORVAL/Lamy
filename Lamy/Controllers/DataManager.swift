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
    
    var musicTracks: [ReceivedSearchItems]!
    
    func fetchData(for searchRequest: String) {
        let fullUrl = baseUrl + searchRequest + entity + country
        print(fullUrl)
        AF.request(fullUrl).response { response in
            if let error = response.error {
                print(error.localizedDescription)
            }
            else {
                guard let result = response.data else { return }
                let string = String(data: result, encoding: .utf8)
                print(string as Any)
            }
        }
    }
    
    private init() {}
}

