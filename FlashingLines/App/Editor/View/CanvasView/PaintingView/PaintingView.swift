//
//  PaintingView.swift
//  29.10.2024
//

import UIKit

final class PaintingView: UIView {
    
    // MARK: Private Properties
    private var lastLocation: CGPoint?
    
    // MARK: Visual Components
    private lazy var drawnView = DrawnPictureView()
    private lazy var undoableView = UndoablePictureView()
    private lazy var drawableView = DrawablePictureView()
    
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
}

// MARK: - Private Methods
extension PaintingView {
    private func addSubviews() {
        addSubview(drawnView)
        addSubview(undoableView)
        addSubview(drawableView)
    }
}
