//
//  PlaylistSwiftUIView.swift
//  Lamy
//
//  Created by mix on 23.4.24..
//

import SwiftUI


struct PlaylistSwiftUIView: View {
    
    @State var playlistTracks = DataManager.shared.loadTracks()

    var body: some View {
        VStack(spacing: 20) {
                GeometryReader(content: { geometry in
                    HStack(spacing: 35) {
                        Button(action: {
                            print("HI")
                        },
                               label: {
                            Image(systemName: "play.square")
                                .frame(width: geometry.size.width, height: 40)
                                .background(Color(.black))
                                .tint(.white)
                                .clipShape(.buttonBorder)
                        })
                    }
                }).padding(.all).frame(height: 40)
    
                Divider().padding(.leading).padding(.trailing)
            if playlistTracks != nil {
                List {
                    ForEach(playlistTracks!) { track in
                        PlaylistSwiftUIViewCell(track: track)
                    }.onAppear(perform: {
                        playlistTracks = DataManager.shared.loadTracks()
                    })
                }
            }
            
        }.padding(.all)
        
    }
}

#Preview {
    PlaylistSwiftUIView()
}

struct PlaylistSwiftUIViewCell: View {
    var track: Track
    
    var body: some View {
            HStack {
                Image(systemName: "cube.transparent").resizable().frame(width: 50, height: 50)
                Divider().padding(.leading)
                VStack {
                    Text(track.trackName)
                    Text(track.artistName)
                }
            }
    }
}

