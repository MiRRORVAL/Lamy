//
//  PlayerViewControlProtocol.swift
//  Lamy
//
//  Created by mix on 18.4.24..
//

import Foundation

protocol PlayerViewControlProtocol: AnyObject {
    func minimizePlayerView()
    func maximizePlayerView(play track: Track?)
}
