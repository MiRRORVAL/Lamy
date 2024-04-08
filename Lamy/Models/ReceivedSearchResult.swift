//
//  RecivedData.swift
//  Lamy
//
//  Created by Nur on 4/8/24.
//

import Foundation


struct ReceivedSearchResult: Decodable {
    let resultCount: Int
    let result: [ReceivedSearchItems]

}
struct ReceivedSearchItems: Decodable {
    let artistID, collectionID, trackID: Int
    let artistName, collectionName, trackName: String
    let previewURL: String
    let collectionExplicitness, trackExplicitness: String
    let trackTimeMillis: Int
}
