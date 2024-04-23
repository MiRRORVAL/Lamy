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

    var body: some View {
        VStack {
                GeometryReader(content: { geometry in
                        Button(action: {
                            print("HI")
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
                        PlaylistSwiftUIViewCell(track: track)
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

