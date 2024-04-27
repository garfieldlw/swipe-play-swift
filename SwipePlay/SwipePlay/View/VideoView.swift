//
//  VideoView.swift
//  SwipePlay
//
//  Created by Wei Lu on 2024/4/27.
//

import SwiftUI
import AVKit

struct VideoView: View {
    var videoUrl: String
    
    @State var player: AVPlayer = AVPlayer()
    
    var body: some View {
        ZStack {
            VideoPlayerView(videoURL: self.videoUrl, player: self.player)
                .onAppear(){
                    player.play()
                }
                .onDisappear(){
                    player.pause()
                }
                .clipped(antialiased:  true)
        }
    }
}

struct VideoPlayerView: UIViewRepresentable {
    var videoURL: String
    var player: AVPlayer
    
    func makeUIView(context: Context) -> PlayerUIView {
        let u = URL.init(string: videoURL)
        return PlayerUIView.init(frame: CGRect.zero, videoURL: u!, player: self.player)
    }
    
    func updateUIView(_ uiView: PlayerUIView, context: Context) {
        // Update code if needed
    }
}

class PlayerUIView: UIView {
    private var player: AVPlayer?
    
    private var playerItem: AVPlayerItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, videoURL: URL, player: AVPlayer) {
        super.init(frame: frame)
        setup(videoURL: videoURL, player: player)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
    }
    
    func setup(videoURL: URL, player: AVPlayer) {
        self.player = player
        
        let playerLayer = AVPlayerLayer(player: self.player)
        layer.addSublayer(playerLayer)
        
        self.playerItem = AVPlayerItem(url: videoURL)
        
        self.player?.replaceCurrentItem(with: self.playerItem)
        
        self.player?.addObserver(self, forKeyPath: #keyPath(AVPlayer.timeControlStatus), options: [.new], context: nil)
    }
    
    func play(){
        self.player?.play()
    }
    
    func pause() {
        self.player?.pause()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let playerLayer = layer.sublayers?.first as? AVPlayerLayer {
            playerLayer.frame = bounds
            playerLayer.videoGravity = .resizeAspectFill
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayer.timeControlStatus) {
            if let newValue = change?[.newKey] as? Int, let status = AVPlayer.TimeControlStatus(rawValue: newValue) {
                if status == .paused {
                    // 播放暂停时检查是否播放完成
                    if self.player?.currentTime() == self.player?.currentItem?.duration {
                        self.player?.seek(to: .zero)
                        self.player?.play()
                    }
                }
            }
        }
    }
}
