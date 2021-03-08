//
//  SuperPlayerRepresentable.swift
//  AVPlayer Study
//
//  Created by Adriano Souza Costa on 04/03/21.
//

import UIKit

public enum PlayerAspectRatio {
    case expanded
    case condensed
}

public protocol SuperPlayerRepresentable where Self: UIViewController {
    
    var items: [URL] { get }
    var currentItem: URL? { get }
    var playerView: UIView { get }
    var totalTime: TimeInterval? { get }
    var currentTime: TimeInterval? { get }
    
    func play()
    func pause()
    func next()
    func prev()
    func toggleGravity()
    
}

extension SuperPlayerRepresentable {
    
    func embed(in controller: UIViewController) {
        playerView.frame = controller.view.bounds
        controller.view.addSubview(playerView)
        playerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        controller.addChild(self)
    }
    
}
