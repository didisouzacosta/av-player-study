//
//  SuperPlayer.swift
//  AVPlayer Study
//
//  Created by Adriano Souza Costa on 07/03/21.
//

import Foundation
import AVKit
import UIKit

enum PlayerStatus {
    case playning
    case paused
}

final class SuperPlayer: UIViewController {
    
    // MARK: - Private Properties
    
    private let notification = NotificationCenter.default
    
    private var _items: [URL] = []
    private var _currentItem: URL?
    
    private var canDisplayHUD = true {
        didSet { updateHUD() }
    }
    
    private var status: PlayerStatus = .paused {
        didSet {
            canDisplayHUD = status == .paused
            updateVideoReproductionState()
            setupReproductionButton()
        }
    }
    
    private var currentIndex: Int? {
        guard let currentItem = currentItem else { return nil }
        return items.firstIndex(of: currentItem)
    }
    
    private lazy var airplayButton: AVRoutePickerView = {
        let routePicker = AVRoutePickerView()
        routePicker.prioritizesVideoDevices = true
        routePicker.delegate = self
        return routePicker
    }()
    
    private lazy var playerController: AVPlayerViewController = {
        let controller = AVPlayerViewController()
        controller.player?.allowsExternalPlayback = true
        return controller
    }()
    
    // MARK: Outlets
    
    @IBOutlet private var playerContainerView: UIView!
    @IBOutlet private var hudContainerView: UIView!
    @IBOutlet private var overlayView: UIView!
    @IBOutlet private var airPlayContainerView: UIView!
    @IBOutlet private var reproductionButton: UIButton!
    @IBOutlet private var actionLayers: [UIView] = []
    
    // MARK: - Public Methods
    
    init(items: [URL]) {
        super.init(nibName: nil, bundle: nil)
        self._items = items
        self._currentItem = items.first
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPlayer()
        setupAirPlayButton()
        setupActionLayers()
        setupReproductionButton()

        registerEvents()

        updateHUD()
        updateVideoReproductionState()
    }
    
    // MARK: - Private Methods
    
    private func setupAirPlayButton() {
        airplayButton.frame = airPlayContainerView.bounds
        airplayButton.tintColor = .white
        airPlayContainerView.addSubview(airplayButton)
    }
    
    private func setupPlayer() {
        playerController.view.frame = playerContainerView.bounds
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
    
    private func setupReproductionButton() {
        let image = Assets.icon(with: status)
        reproductionButton.setImage(image, for: .normal)
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
        case .paused: pause()
        case .playning: play()
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
        case .paused: status = .playning
        case .playning: status = .paused
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
    
    @IBAction private func willEnterForeground() {
        playerController.showsPlaybackControls = false
    }
    
    @IBAction private func didEnterBackground() {
        playerController.showsPlaybackControls = true
    }
    
}

extension SuperPlayer: SuperPlayerRepresentable {
    
    var items: [URL] {
        return _items
    }
    
    var currentItem: URL? {
        return _currentItem
    }
    
    var playerView: UIView {
        return view
    }
    
    var totalTime: TimeInterval? {
        return nil
    }
    
    var currentTime: TimeInterval? {
        return nil
    }
    
    func play() {
        guard let current = currentItem else { return }
        
        if playerController.player == nil {
            let player = AVPlayer(url: current)
            playerController.player = player
        }
        
        playerController.player?.play()
    }
    
    func pause() {
        playerController.player?.pause()
    }
    
    func next() {
        guard let currentIndex = currentIndex else { return }
        guard let nextItem = items[safeIndex: currentIndex + 1] else { return }
        
        _currentItem = nextItem
        
        play()
    }
    
    func prev() {
        guard let currentIndex = currentIndex else { return }
        guard let prevItem = items[safeIndex: currentIndex - 1] else { return }
        
        _currentItem = prevItem
        
        play()
    }
    
    func toggleGravity() {
        togglePlayerGravity()
    }
    
}

extension SuperPlayer: AVRoutePickerViewDelegate {}

private extension Assets {
    
    static func icon(with status: PlayerStatus) -> UIImage {
        switch status {
        case .paused: return Assets.icon.play
        case .playning: return Assets.icon.pause
        }
    }
    
}

private extension Array {
    
    subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
    
}
