//
//  PlaylistSwiftUIView.swift
//  Lamy
//
//  Created by mix on 23.4.24..
//

import SwiftUI
import SDWebImageSwiftUI


struct PlaylistSwiftUIView: View {
    
    
    @State var playlistTracks = DataManager.shared.loadTracks()
    let dataManager = DataManager.shared
    var delegate: PlayerViewControlProtocol?
    static var pointer: Int = 0
    
    var body: some View {
        VStack {
                GeometryReader(content: { geometry in
                        Button(action: {
                            delegate?.setPlayerViewDelegate(asPlaylist: true)
                            delegate?.maximizePlayerView(play: playlistTracks?.first)
                        },
                               label: {
                            Image(systemName: "play")
                                .gridCellAnchor(.center)
                                .frame(width: geometry.size.width - 20, height: 40)
                                .background(Color(.black))
                                .tint(.white)
                                .clipShape(.capsule)
                        }).padding(10)
                }).frame(height: 40)
    
                Divider().padding(.leading).padding(.trailing)
                List {
                    ForEach(playlistTracks!) { track in
                        PlaylistSwiftUIViewCell(track: track).onTapGesture {
                            delegate?.setPlayerViewDelegate(asPlaylist: true)
                            delegate?.maximizePlayerView(play: track)
                        }
                    }.onDelete(perform: { indexSet in
                        DataManager.shared.delete(indexSet.first)
                        playlistTracks = DataManager.shared.loadTracks()
                    })
            }.onAppear(perform: {
                playlistTracks = DataManager.shared.loadTracks()
            })
            
        }
        
    }
}

#Preview {
    PlaylistSwiftUIView()
}

struct PlaylistSwiftUIViewCell: View {
    var track: Track
    
    var body: some View {
            HStack {
                WebImage(url: URL(string: track.artworkUrl100!) ) { image in
                    image.resizable().frame(width: 60, height: 60)
                } placeholder: {
                    Image(systemName: "cube.transparent").resizable().frame(width: 60, height: 60)
                }
                VStack(alignment: .leading) {
                    Text(track.trackName).padding(.leading).bold()
                    Text(track.artistName).padding(.leading).font(.footnote).italic()
                }.padding(.all)
            }.frame(height: 70)
    }
}
extension PlaylistSwiftUIView: TransferInfoToPlayerViewProtocol {
    
    func moveBack() -> Track? {
        let count = dataManager.playlisTracks.count - 1
        PlaylistSwiftUIView.pointer = PlaylistSwiftUIView.pointer - 1 < 0 ? count : PlaylistSwiftUIView.pointer - 1
        let track = playlistTracks![PlaylistSwiftUIView.pointer]
        return track
    }
    
    func moveForward() -> Track? {
        let count = dataManager.playlisTracks.count - 1
        PlaylistSwiftUIView.pointer = PlaylistSwiftUIView.pointer + 1 > count ? 0 : PlaylistSwiftUIView.pointer + 1
        let track = playlistTracks![PlaylistSwiftUIView.pointer]
        return track
    }
}
