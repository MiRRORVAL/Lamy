//
//  Music.swift
//  Lamy
//
//  Created by Nur on 4/8/24.
//

import Foundation
import SwiftUI

struct Track: Codable, Identifiable {
    
    var id = UUID()
    
    var artistName: String
    var collectionName: String?
    var trackName: String
    var trackTimeMillis: Int?
    var artworkUrl100: String?
    let previewUrl: String?
}
