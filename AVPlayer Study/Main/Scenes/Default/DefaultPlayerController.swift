//
//  DefaultPlayerController.swift
//  AVPlayer Study
//
//  Created by Adriano Souza Costa on 16/02/21.
//

import UIKit
import AVKit

final class DefaultPlayerController: UIViewController {

    // MARK: - Private Properties
    
    private lazy var playerController: AVPlayerViewController = {
        let player = AVPlayer(url: Constants.videoURL)
        
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsTimecodes = true
        
        return controller
    }()
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
    }
    
    // MARK: - Private Methods
    
    private func setupPlayer() {
        playerController.view.frame = view.bounds
        view.addSubview(playerController.view)
        addChild(playerController)
        playerController.view.frame = view.frame
        
        playerController.player?.play()
    }

}

