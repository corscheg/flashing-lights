//
//  PaintingView.swift
//  29.10.2024
//

import UIKit

final class PaintingView: UIView {
    
    // MARK: Private Properties
    private let opacities: any Opacities
    private var lastLocation: CGPoint?
    private var lastEraseLocation: CGPoint?
    private var maskSet: Bool = false
    private var storedMaskImage: UIImage?
    
    // MARK: Visual Components
    private lazy var maskedView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        
        return view
    }()
    private lazy var drawnView = DrawnPictureView()
    private lazy var undoableView = UndoablePictureView()
    private lazy var drawableView = DrawablePictureView()
    private lazy var assistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = opacities.assist
        
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
        maskedView.frame = bounds
        drawnView.frame = maskedView.bounds
        undoableView.frame = maskedView.bounds
        drawableView.frame = maskedView.bounds
        
        if !maskSet {
            setDefaultMask()
            maskSet = true
        }
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
    
    func clear() {
        drawnView.clear()
        undoableView.clear()
        drawnView.clear()
    }
    
    func setDrawnImage(_ image: UIImage) {
        drawnView.clear()
        drawnView.mergeImage(image)
    }
    
    func startErase(at location: CGPoint) {
        lastEraseLocation = location
    }
    
    func continueErase(to location: CGPoint, width: CGFloat) {
        addErase(to: location, width: width, resetLocation: false)
    }
    
    func endErase(at location: CGPoint, width: CGFloat) {
        addErase(to: location, width: width, resetLocation: true)
    }
    
    func commitErase() {
        guard let storedMaskImage else { return }
        drawnView.mergeMask(storedMaskImage)
        setDefaultMask()
    }
}

// MARK: - Private Methods
extension PaintingView {
    private func addSubviews() {
        addSubview(assistImageView)
        addSubview(maskedView)
        maskedView.addSubview(drawnView)
        maskedView.addSubview(undoableView)
        maskedView.addSubview(drawableView)
    }
    
    private func setDefaultMask() {
        let blackImage = UIGraphicsImageRenderer(size: bounds.size).image { context in
            UIColor.black.setFill()
            context.fill(bounds)
        }
        
        let maskLayer = CALayer()
        let maskImage = blackImage.cgImage
        storedMaskImage = blackImage
        maskLayer.frame = bounds
        maskLayer.contents = maskImage
        
        maskedView.layer.mask = maskLayer
    }
    
    private func addErase(to location: CGPoint, width: CGFloat, resetLocation: Bool) {
        guard let lastEraseLocation else { return }
        guard let storedMaskImage else { return }
        
        let newMaskImage = UIGraphicsImageRenderer(size: bounds.size).image { context in
            storedMaskImage.draw(in: bounds)
            
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(width)
            context.cgContext.setLineCap(.round)
            context.cgContext.setBlendMode(.clear)
            context.cgContext.move(to: lastEraseLocation)
            context.cgContext.addLine(to: location)
            context.cgContext.strokePath()
        }
        
        maskedView.layer.mask?.contents = newMaskImage.cgImage
        self.storedMaskImage = newMaskImage
        
        if resetLocation {
            self.lastEraseLocation = nil
        } else {
            self.lastEraseLocation = location
        }
    }
}
