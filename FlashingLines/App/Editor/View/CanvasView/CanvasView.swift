//
//  CanvasView.swift
//  28.10.2024
//

import UIKit

final class CanvasView: UIView {
    
    // MARK: Private Properties
    private let cornerRadiuses: any CornerRadiuses
    private let images: any Images
    
    // MARK: Visual Components
    private lazy var paperView: UIImageView = {
        let imageView = UIImageView(image: images.paper)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = cornerRadiuses.large
        imageView.layer.cornerCurve = .continuous
        
        return imageView
    }()
    
    // MARK: Initializers
    init(frame: CGRect, cornerRadiuses: any CornerRadiuses, images: any Images) {
        self.cornerRadiuses = cornerRadiuses
        self.images = images
        super.init(frame: frame)
        
        addSubviews()
    }
    
    convenience init(cornerRadiuses: any CornerRadiuses, images: any Images) {
        self.init(frame: .zero, cornerRadiuses: cornerRadiuses, images: images)
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
    }
}

// MARK: - Private Methods
extension CanvasView {
    private func addSubviews() {
        addSubview(paperView)
    }
}
