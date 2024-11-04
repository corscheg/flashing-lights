//
//  PlayerView.swift
//  30.10.2024
//

import UIKit

final class PlayerView<Playable: Collection>: UIView where Playable.Element == UIImage {
    
    // MARK: Private Properties
    private var playable: Playable?
    private var playableIndex: Playable.Index?
    private var frameDuration: CFTimeInterval?
    private var screenFrameDuration: CFTimeInterval?
    private var counter: UInt64 = 0
    private var screenFramesPerFrame: Int?
    private var displayLink: CADisplayLink?
    
    // MARK: Visual Components
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        addSubviews()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIView
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
    }
    
    // MARK: Internal Methods
    func play(_ playable: Playable, at framesPerSecond: UInt) {
        guard !playable.isEmpty else { return }
        self.playable = playable
        self.playableIndex = playable.startIndex
        self.frameDuration = 1.0 / CFTimeInterval(framesPerSecond)
        
        displayLink = CADisplayLink(target: self, selector: #selector(didHitDisplayLink(sender:)))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    func stop() {
        playable = nil
        frameDuration = nil
        screenFrameDuration = nil
        counter = 0
        displayLink?.invalidate()
        displayLink = nil
        imageView.image = nil
    }
    
    // MARK: Actions
    @objc
    private func didHitDisplayLink(sender: CADisplayLink) {
        guard let playable, let frameDuration, let playableIndex else { return }
        let screenFramesPerFrame = self.screenFramesPerFrame ?? Int(frameDuration / sender.duration)
        self.screenFramesPerFrame = screenFramesPerFrame
        
        defer {
            if counter == .max {
                counter = 0
            } else {
                counter += 1
            }
        }
        
        guard counter.isMultiple(of: UInt64(screenFramesPerFrame)) else { return }
        
        let image = playable[playableIndex]
        imageView.image = image
        self.playableIndex = playable.index(after: playableIndex)
        
        if self.playableIndex == playable.endIndex {
            self.playableIndex = playable.startIndex
        }
    }
}

// MARK: - Private Methods
extension PlayerView {
    private func addSubviews() {
        addSubview(imageView)
    }
}
