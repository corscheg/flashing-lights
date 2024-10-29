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
    
    // MARK: Visual Components
    private lazy var paperView: UIImageView = {
        let imageView = UIImageView(image: images.paper)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = cornerRadiuses.large
        imageView.layer.cornerCurve = .continuous
        
        return imageView
    }()
    
    private lazy var paintingView = PaintingView()
    private lazy var canvasResponderView = CanvasResponderView(screen: screen)
    
    // MARK: Initializers
    init(frame: CGRect, cornerRadiuses: any CornerRadiuses, images: any Images, screen: UIScreen) {
        self.cornerRadiuses = cornerRadiuses
        self.images = images
        self.screen = screen
        super.init(frame: frame)
        
        addSubviews()
    }
    
    convenience init(cornerRadiuses: any CornerRadiuses, images: any Images, screen: UIScreen) {
        self.init(frame: .zero, cornerRadiuses: cornerRadiuses, images: images, screen: screen)
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
        paintingView.frame = bounds
        canvasResponderView.frame = bounds
    }
    
    // MARK: Internal Methods
    func startDrawing(at start: CGPoint) {
        paintingView.startDrawing(at: start)
    }
    
    func continueDrawing(to point: CGPoint, brushWidth: CGFloat, color: CGColor) {
        paintingView.continueDrawing(to: point, brushWidth: brushWidth, color: color)
    }
    
    func endDrawing(at point: CGPoint, brushWidth: CGFloat, color: CGColor) {
        paintingView.endDrawing(at: point, brushWidth: brushWidth, color: color)
    }
    
    func moveUndoToDrawn() {
        paintingView.moveUndoToDrawn()
    }
    
    func movePaintingToUndo() {
        paintingView.movePaintingToUndo()
    }
}

// MARK: - Private Methods
extension CanvasView {
    private func addSubviews() {
        addSubview(paperView)
        addSubview(paintingView)
        addSubview(canvasResponderView)
    }
}
