//
//  PaintingView.swift
//  29.10.2024
//

import UIKit

final class PaintingView: UIView {
    
    // MARK: Private Properties
    private let opacities: any Opacities
    private var lastLocation: CGPoint?
    
    // MARK: Visual Components
    private lazy var drawnView = DrawnPictureView()
    private lazy var undoableView = UndoablePictureView()
    private lazy var drawableView = DrawablePictureView()
    private lazy var assistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = opacities.assistOpacity
        
        return imageView
    }()
    
    // MARK: Initializers
    init(frame: CGRect, opacities: any Opacities) {
        self.opacities = opacities
        super.init(frame: frame)
        isUserInteractionEnabled = false
        addSubviews()
    }
    
    convenience init(opacities: any Opacities) {
        self.init(frame: .zero, opacities: opacities)
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
        assistImageView.frame = bounds
        drawnView.frame = bounds
        undoableView.frame = bounds
        drawableView.frame = bounds
    }
    
    // MARK: Internal Methods
    func startDrawing(at start: CGPoint) {
        lastLocation = start
    }
    
    func continueDrawing(to point: CGPoint, brushWidth: CGFloat, color: CGColor) {
        guard let lastLocation else { return }
        
        drawableView.addLine(from: lastLocation, to: point, brushWidth: brushWidth, color: color)
        self.lastLocation = point
    }
    
    func endDrawing(at point: CGPoint, brushWidth: CGFloat, color: CGColor) {
        guard let lastLocation else { return }
        
        drawableView.addLine(from: lastLocation, to: point, brushWidth: brushWidth, color: color)
        self.lastLocation = nil
    }
    
    func moveUndoToDrawn() {
        guard let undoImage = undoableView.image else { return }
        drawnView.mergeImage(undoImage)
        undoableView.clear()
    }
    
    func movePaintingToUndo() {
        guard let drawableImage = drawableView.image else { return }
        undoableView.clearBuffer()
        undoableView.setImage(drawableImage)
        drawableView.clear()
    }
    
    func performUndo() {
        undoableView.undo()
    }
    
    func performRedo() {
        undoableView.redo()
    }
    
    func takeCurrentImage() -> UIImage? {
        defer { drawnView.clear() }
        return drawnView.image
    }
    
    func setAssistImage(_ image: UIImage?) {
        assistImageView.image = image
    }
}

// MARK: - Private Methods
extension PaintingView {
    private func addSubviews() {
        addSubview(assistImageView)
        addSubview(drawnView)
        addSubview(undoableView)
        addSubview(drawableView)
    }
}
