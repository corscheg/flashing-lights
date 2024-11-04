//
//  ColorButton.swift
//  31.10.2024
//

import UIKit

final class ColorButton: UIButton {
    
    // MARK: Private Properties
    private let layout: any Layout
    private let colors: any InterfaceColors
    
    // MARK: Visual Components
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.borderColor = isSelected ? colors.accent.cgColor : colors.outlineBorder.cgColor
        view.layer.borderWidth = isSelected ? layout.borders.regular : layout.borders.thinRegular
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    // MARK: Initializers
    init(frame: CGRect, layout: any Layout, colors: any InterfaceColors) {
        self.layout = layout
        self.colors = colors
        super.init(frame: frame)
        addSubview(colorView)
    }
    
    convenience init(layout: any Layout, colors: any InterfaceColors) {
        self.init(frame: .zero, layout: layout, colors: colors)
    }
    
    convenience init(layout: any Layout, colors: any InterfaceColors, initialColor: UIColor) {
        self.init(layout: layout, colors: colors)
        setColor(initialColor)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIView
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layout.sizes.regularButton
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let inset = layout.spacings.tiny
        colorView.frame = bounds.inset(by: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
        colorView.layer.cornerRadius = min(colorView.frame.width, colorView.frame.height) / 2.0
    }
    
    // MARK: UIControl
    override var isSelected: Bool {
        get {
            super.isSelected
        } set {
            super.isSelected = newValue
            setSelected(newValue)
        }
    }
    
    override var isEnabled: Bool {
        get {
            super.isEnabled
        } set {
            super.isEnabled = newValue
            setEnabled(newValue)
        }
    }
    
    // MARK: Internal Methods
    func setColor(_ color: UIColor) {
        colorView.backgroundColor = color
    }
}

// MARK: - Private Methods
extension ColorButton {
    private func addSubviews() {
        addSubview(colorView)
    }
    
    private func setSelected(_ selected: Bool) {
        colorView.layer.borderColor = selected ? colors.accent.cgColor : colors.outlineBorder.cgColor
        colorView.layer.borderWidth = selected ? layout.borders.regular : layout.borders.thinRegular
    }
    
    private func setEnabled(_ enabled: Bool) {
        colorView.alpha = enabled ? 1.0 : colors.opacities.disabled
    }
}
