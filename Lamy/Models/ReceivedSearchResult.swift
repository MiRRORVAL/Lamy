//
//  RecivedData.swift
//  Lamy
//
//  Created by Nur on 4/8/24.
//

import Foundation


struct ReceivedSearchResult: Decodable {
    let resultCount: Int
    let results: [ReceivedSearchItems]
}

struct ReceivedSearchItems: Decodable {
    let artistName: String
    let collectionName: String?
    let trackID: Int?
    let trackName: String
    let trackTimeMillis: Int
    let artworkUrl100: String
    let previewUrl: String
}
