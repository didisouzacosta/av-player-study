//
//  ViewController.swift
//  AVPlayer Study
//
//  Created by Adriano Souza Costa on 16/02/21.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    // MARK: - Private Properties
    
    private lazy var playerController: AVPlayerViewController = {
        let videoURL = URL(string: "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4")
        let controller = AVPlayerViewController()
        controller.player = AVPlayer(url: videoURL!)
        return controller
    }()
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
        play()
    }
    
    // MARK: - Private Methods
    
    private func setupPlayer() {
        playerController.view.frame = view.bounds
        view.addSubview(playerController.view)
        addChild(playerController)
        playerController.view.frame = view.frame
    }
    
    private func play() {
        playerController.player?.play()
    }

}

