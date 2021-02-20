//
//  LayerOnlyController.swift
//  AVPlayer Study
//
//  Created by Adriano Souza Costa on 16/02/21.
//

import UIKit
import AVKit

final class LayerOnlyController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var playerLayer: AVPlayerLayer = {
        let layer = AVPlayerLayer()
        layer.videoGravity = .resizeAspect
        return layer
    }()
    
    // MARK: - Public Methods
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try? AVAudioSession.sharedInstance().setCategory(
            AVAudioSession.Category.playback,
            options: .mixWithOthers
        )
        
        setupPlayer()
        play(video: Constants.videoURL)
    }
    
    // MARK: - Private Methods
    
    private func setupPlayer() {
        view.layer.addSublayer(playerLayer)
    }
    
    private func play(video url: URL) {
        let player = AVPlayer(url: url)
        player.allowsExternalPlayback = true
        
        playerLayer.player = player
        player.appliesMediaSelectionCriteriaAutomatically = true
        player.play()
    }
    
}
