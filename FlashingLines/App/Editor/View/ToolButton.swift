//
//  ToolButton.swift
//  28.10.2024
//

import UIKit

final class ToolButton: UIButton {
    
    // MARK: Private Properties
    private let colors: any InterfaceColors
    private let sizes: any Sizes
    private let size: Size
    
    // MARK: Initializers
    init(colors: any InterfaceColors, sizes: any Sizes, size: Size, image: UIImage) {
        self.colors = colors
        self.sizes = sizes
        self.size = size
        super.init(frame: .zero)
        var config: UIButton.Configuration = .plain()
        config.baseBackgroundColor = .clear
        config.image = image
        self.configuration = config
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIView
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard bounds.width < sizes.minimalTapArea.width || bounds.height < sizes.minimalTapArea.height else {
            return super.point(inside: point, with: event)
        }
        
        let dx = min(0, (bounds.width - sizes.minimalTapArea.width) / 2)
        let dy = min(0, (bounds.height - sizes.minimalTapArea.height) / 2)
        return bounds.insetBy(dx: dx, dy: dy).contains(point)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        switch self.size {
        case .small:
            sizes.smallButton
        case .regular:
            sizes.regularButton
        }
    }
    
    // MARK: UIButton
    override func updateConfiguration() {
        guard let configuration else { return }
        
        var newConfig = configuration
        
        newConfig.baseForegroundColor = switch state {
        case .normal, .focused, .reserved, .application:
            colors.button
        case .disabled, .highlighted:
            colors.disabled
        case .selected:
            colors.accent
        default:
            colors.button
        }
        
        self.configuration = newConfig
    }
}

// MARK: - Size
extension ToolButton {
    enum Size {
        case small
        case regular
    }
}
