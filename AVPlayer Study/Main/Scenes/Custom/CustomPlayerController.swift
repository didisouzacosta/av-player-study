//
//  CustomPlayerController.swift
//  AVPlayer Study
//
//  Created by Adriano Souza Costa on 19/02/21.
//

import Foundation
import UIKit

final class CustomPlayerController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var player = SuperPlayer(items: [Constants.videoURL])
    
    // MARK: - Public Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
    }
    
    // MARK: - Private Properties
    
    private func setupPlayer() {
        player.embed(in: self)
    }
    
}
