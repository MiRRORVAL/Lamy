//
//  PlayerView.swift
//  Lamy
//
//  Created by mix on 12.4.24..
//

import UIKit
import AVKit
import SDWebImage


class PlayerView: UIView {
    
    @IBOutlet weak var miniPlayButton: UIButton!
    @IBOutlet weak var miniNameLable: UILabel!
    @IBOutlet weak var miniImageView: UIImageView!
    @IBOutlet weak var miniView: UIView!
    @IBOutlet weak var maxView: UIStackView!
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
    @IBOutlet weak var miniButtonsStackView: UIStackView!
    
    weak var delegate: TransferInfoToPlayerViewProtocol?
    weak var playerControlDelegate: PlayerViewControlProtocol?
    var baseColor: UIColor!
    
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
        miniButtonsStackView.layer.cornerRadius = miniButtonsStackView.frame.height / 2
        volumeSlider.value = playerAV.volume
        gestureRecognizer()
        nextButtone.transform = .init(scaleX: 0.5, y: 0.5)
        prevButton.transform = .init(scaleX: 0.5, y: 0.5)
        nextButtone.layer.cornerRadius = size.width / 2
        prevButton.layer.cornerRadius = size.width / 2
        playButton.backgroundColor = .black.withAlphaComponent(0.5)
        prevButton.backgroundColor = .black.withAlphaComponent(0.5)
        nextButtone.backgroundColor = .black.withAlphaComponent(0.5)
        miniView.backgroundColor = .clear
        maxView.backgroundColor = .clear
    }
    
    @IBAction func prevButtonPressed(_ sender: Any) {
        guard let track = delegate?.moveBack() else { return }
        setupView(with: track)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        guard let track = delegate?.moveForward() else { return }
        setupView(with: track)
    }

    @IBAction func playButtonePressed(_ sender: Any) {
        playButtonSetup()
    }

    @IBAction func songSliderMuved(_ sender: Any) {
    }
    
    @IBAction func volumeSliderMuved(_ sender: Any) {
        playerAV.volume = volumeSlider.value
    }
    
    @IBAction func exitButtonePressed(_ sender: Any) {
        playerControlDelegate?.minimizePlayerView()
    }
    
    private func playButtonSetup() {
        if playerAV.timeControlStatus == .playing {
            playerAV.pause()
            let image = UIImage(systemName: "play.fill")
            miniPlayButton.setImage(image, for: .normal)
            playButton.setImage(image, for: .normal)
            imageScale = 0.8
        } else {
            playerAV.play()
            let image = UIImage(systemName: "pause.fill")
            miniPlayButton.setImage(image, for: .normal)
            playButton.setImage(image, for: .normal)
            imageScale = 1
        }
    }
    private func updateSecondsCounter() {
        let interval = CMTimeMake(value: 1, timescale: 3)
        playerAV.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            self.timeInSeconds()
            let timer = time.seconds / 60
            self.songTimerLeft.text = String(timer)
            guard let duration = self.playerAV.currentItem?.duration.seconds else { return }
            let revirsedTimer = duration - timer
            self.songTimerRight.text = " -\(String(revirsedTimer))"
        }
    }
    
    private func timeInSeconds() {
        let timeNow = CMTimeGetSeconds(playerAV.currentItem?.currentTime() ?? CMTime())
        let duration = CMTimeGetSeconds(playerAV.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = timeNow / duration
        songSlider.value = Float(percentage)
    }
    
    private func playSong(from url: String) {
        guard let url = URL(string: url) else { return }
        let playerItem = AVPlayerItem(url: url)
        playerAV.replaceCurrentItem(with: playerItem)
        playerAV.play()
    }
    
    private func gestureRecognizer() {
            let gest = UITapGestureRecognizer(target: self,
                                           action: #selector(muveViewByGuewture))
            addGestureRecognizer(gest)
    }
    
    @objc private func muveViewByGuewture() {
        if miniView.isHidden {
            self.backgroundColor = baseColor.withAlphaComponent(0.7)
            playerControlDelegate?.minimizePlayerView()
        } else {
            self.backgroundColor = baseColor.withAlphaComponent(0.98)
            playerControlDelegate?.maximizePlayerView(play: nil)
        }
    }
    
    
    func setupView(with info: Track) {
        songAuthor.text = info.artistName
        songName.text = info.trackName
        miniNameLable.text = info.trackName
        updateSecondsCounter()
        let imageUrl: URL? = {
            let urlString = info.artworkUrl100?.replacingOccurrences(of: "100x100", with: "600x600")
            guard let url = URL(string: urlString!) else { return nil }
            return url
        }()
        let plaseholderImage = UIImage(systemName: "cube.transparent")
        miniImageView.sd_setImage(with: imageUrl, placeholderImage: plaseholderImage)
        trackImage.sd_setImage(with: imageUrl, placeholderImage: plaseholderImage, options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            let image: UIImage = self.miniImageView.image!
            let backgroundColor: UIColor = image.averageColor!
            self.baseColor = backgroundColor
            self.backgroundColor = backgroundColor.withAlphaComponent(0.98)
            if !self.miniView.isHidden {
                self.backgroundColor = backgroundColor.withAlphaComponent(0.7)
            }
           })
        guard let previewUrl = info.previewUrl else { return }
        playSong(from: previewUrl)
    }

}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}
