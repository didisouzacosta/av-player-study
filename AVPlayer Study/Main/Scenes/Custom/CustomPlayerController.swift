//
//  CustomPlayerController.swift
//  AVPlayer Study
//
//  Created by Adriano Souza Costa on 19/02/21.
//

import Foundation
import UIKit
import AVKit

enum PlayerStatus {
    case started
    case paused
}

final class CustomPlayerController: UIViewController {
    
    // MARK: - Private Properties
    
    private let notification = NotificationCenter.default
    
    private var canDisplayHUD = true {
        didSet { updateHUD() }
    }
    
    private var status: PlayerStatus = .paused {
        didSet {
            canDisplayHUD = status == .paused
            updateVideoReproductionState()
        }
    }
    
    private var player = AVPlayer(url: Constants.videoURL) {
        didSet { playerController.player = player }
    }
    
    private lazy var airplayButton: AVRoutePickerView = {
        let routePicker = AVRoutePickerView()
        routePicker.prioritizesVideoDevices = true
        routePicker.delegate = self
        return routePicker
    }()
    
    private lazy var playerController: AVPlayerViewController = {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.player?.allowsExternalPlayback = true
        return controller
    }()
    
    // MARK: Outlets
    
    @IBOutlet private var playerContainerView: UIView!
    @IBOutlet private var hudContainerView: UIView!
    @IBOutlet private var overlayView: UIView!
    @IBOutlet private var airPlayContainerView: UIView!
    @IBOutlet private var actionLayers: [UIView] = []
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPlayer()
        setupActionLayers()
        
        registerEvents()
        
        updateHUD()
        updateVideoReproductionState()
        
        setupAirPlayButton()
    }
    
    // MARK: - Private Methods
    
    private func setupAirPlayButton() {
        airplayButton.frame = airPlayContainerView.bounds
        airplayButton.tintColor = .white
        airPlayContainerView.addSubview(airplayButton)
    }
    
    private func setupPlayer() {
        playerController.view.frame = playerContainerView.bounds
        playerController.view.frame = playerContainerView.frame
        playerContainerView.addSubview(playerController.view)
        playerController.view.translatesAutoresizingMaskIntoConstraints = false
        playerController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        addChild(playerController)
        
        try? AVAudioSession.sharedInstance().setCategory(
            AVAudioSession.Category.playback,
            options: .mixWithOthers
        )
    }
    
    private func setupActionLayers() {
        actionLayers.forEach { view in
            let tap = UITapGestureRecognizer(
                target: self,
                action: #selector(toggleHUDDisplay)
            )
            
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(tap)
        }
    }
    
    private func registerEvents() {
        notification.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIScene.willEnterForegroundNotification,
            object: nil
        )
        
        notification.addObserver(
            self,
            selector: #selector(didEnterBackground),
            name: UIScene.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    private func updateVideoReproductionState() {
        switch (status) {
        case .paused: player.pause()
        case .started: player.play()
        }
    }
    
    private func updateHUD() {
        let status = canDisplayHUD
        UIView.animate(withDuration: 0.26) { [weak self] in
            self?.overlayView.alpha = status ? 0.6 : 0
            self?.hudContainerView.alpha = status ? 1 : 0
        }
    }
    
    // MARK: Actions
    
    @IBAction private func toggleVideoReproduction() {
        switch status {
        case .paused: status = .started
        case .started: status = .paused
        }
    }
    
    @IBAction private func toggleHUDDisplay() {
        canDisplayHUD = !canDisplayHUD
    }
    
    @IBAction private func togglePlayerGravity() {
        switch playerController.videoGravity {
        case .resizeAspect: playerController.videoGravity = .resizeAspectFill
        default: playerController.videoGravity = .resizeAspect
        }
    }
    
    @IBAction private func pictureToPicture() {
        
//        playerController.player?.allowsExternalPlayback = false
//        playerController.player?.usesExternalPlaybackWhileExternalScreenIsActive = true
        print("aeee")
    }
    
    @IBAction private func willEnterForeground() {
        playerController.showsPlaybackControls = false
    }
    
    @IBAction private func didEnterBackground() {
        playerController.showsPlaybackControls = true
    }
    
}

extension CustomPlayerController: AVRoutePickerViewDelegate {
    
    
    
}
