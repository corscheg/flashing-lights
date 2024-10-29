//
//  PictureView.swift
//  29.10.2024
//

import UIKit

class PictureView: UIView {

    // MARK: Visual Components
    let imageView: UIImageView = {
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
    var image: UIImage? { imageView.image }
    
    func clear() {
        imageView.image = nil
    }
}

// MARK: - Private Methods
extension PictureView {
    private func addSubviews() {
        addSubview(imageView)
    }
}
