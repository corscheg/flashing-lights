//
//  CanvasView.swift
//  28.10.2024
//

import Combine
import UIKit

final class CanvasView: UIView {
    
    // MARK: Internal Properties
    var eventPublisher: some Publisher<TouchEvent, Never> {
        canvasResponderView.eventPublisher
    }
    
    // MARK: Private Properties
    private let cornerRadiuses: any CornerRadiuses
    private let images: any Images
    private let screen: UIScreen
    private let device: MTLDevice
    private let metalFunctionName: String
    
    // MARK: Visual Components
    private lazy var paperView: UIImageView = {
        let imageView = UIImageView(image: images.paper)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = cornerRadiuses.large
        imageView.layer.cornerCurve = .continuous
        
        return imageView
    }()
    
    private lazy var canvasResponderView = CanvasResponderView(screen: screen)
    private lazy var drawingView = DrawingView(device: device, functionName: metalFunctionName)
    
    // MARK: Initializers
    init(
        frame: CGRect,
        cornerRadiuses: any CornerRadiuses,
        images: any Images,
        screen: UIScreen,
        device: MTLDevice,
        metalFunctionName: String
    ) {
        self.cornerRadiuses = cornerRadiuses
        self.images = images
        self.screen = screen
        self.device = device
        self.metalFunctionName = metalFunctionName
        super.init(frame: frame)
        
        addSubviews()
    }
    
    convenience init(
        cornerRadiuses: any CornerRadiuses,
        images: any Images,
        screen: UIScreen,
        device: MTLDevice,
        metalFunctionName: String
    ) {
        self.init(
            frame: .zero,
            cornerRadiuses: cornerRadiuses,
            images: images,
            screen: screen,
            device: device,
            metalFunctionName: metalFunctionName
        )
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
        
        paperView.frame = bounds
        drawingView.frame = bounds
        canvasResponderView.frame = bounds
    }
    
    // MARK: Internal Methods
    func updatePaintings(_ paintings: [Painting]) {
        drawingView.updatePaintings(paintings)
    }
}

// MARK: - Private Methods
extension CanvasView {
    private func addSubviews() {
        addSubview(paperView)
        addSubview(drawingView)
        addSubview(canvasResponderView)
    }
}
