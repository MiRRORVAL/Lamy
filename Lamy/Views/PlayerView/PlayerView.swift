//
//  PlayerView.swift
//  Lamy
//
//  Created by mix on 12.4.24..
//

import UIKit
import AVKit


class PlayerView: UIView {
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var songSlider: UISlider!
    @IBOutlet weak var nextButtone: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var songAuthor: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var songTimerLeft: UILabel!
    @IBOutlet weak var songTimerRight: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    
    var imageScale: Double = 1 {
        didSet {
            UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveLinear) {
                self.trackImage.transform = CGAffineTransform(scaleX: self.imageScale,
                                                              y: self.imageScale)
            }
        }
    }
    
    let playerAV = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let size = playButton.frame
        playButton.layer.cornerRadius = size.width / 2
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
    }
    @IBAction func playButtonePressed(_ sender: Any) {
        if playerAV.timeControlStatus == .playing {
            playerAV.pause()
            let image = UIImage(systemName: "play.fill")
            playButton.setImage(image, for: .normal)
            imageScale = 0.8
        } else {
            playerAV.play()
            let image = UIImage(systemName: "pause.fill")
            playButton.setImage(image, for: .normal)
            imageScale = 1
        }
    }
    @IBAction func prevButtonPressed(_ sender: Any) {
    }
    @IBAction func songSliderMuved(_ sender: Any) {
    }
    @IBAction func volumeSliderMuved(_ sender: Any) {
    }
    @IBAction func exitButtonePressed(_ sender: Any) {
        
        self.removeFromSuperview()
    }
    
    private func updateSecondsCounter() {
        let interval = CMTimeMake(value: 1, timescale: 3)
        playerAV.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            let timer = time.seconds / 60
            self.songTimerLeft.text = String(timer)
            guard let duration = self.playerAV.currentItem?.duration.seconds else { return }
            let revirsedTimer = duration - timer
            print(timer)
            print(revirsedTimer)
            self.songTimerRight.text = " -\(String(revirsedTimer))"
        }
    }
    
    private func playSong(from url: String) {
        guard let url = URL(string: url) else { return }
        let playerItem = AVPlayerItem(url: url)
        playerAV.replaceCurrentItem(with: playerItem)
        playerAV.play()
    }
    
    func setupView(with info: Track) {
//    volumeSlider
        songAuthor.text = info.artistName
        songName.text = info.trackName
        updateSecondsCounter()
        let imageUrl: URL? = {
            let urlString = info.artworkUrl100?.replacingOccurrences(of: "100x100", with: "600x600")
            guard let url = URL(string: urlString!) else { return nil}
            return url
        }()
        let plaseholderImage = UIImage(systemName: "cube.transparent")
        trackImage.sd_setImage(with: imageUrl, placeholderImage: plaseholderImage)
        guard let previewUrl = info.previewUrl else { return }
        playSong(from: previewUrl)

    }
}
