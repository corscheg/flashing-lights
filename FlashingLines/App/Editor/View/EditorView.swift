//
//  EditorView.swift
//  28.10.2024
//

import UIKit

final class EditorView: UIView {
    // MARK: Private Properties
    private let colors: any Colors
    private let icons: any Icons
    
    // MARK: Initializers
    init(frame: CGRect, colors: any Colors, icons: any Icons) {
        self.colors = colors
        self.icons = icons
        super.init(frame: frame)
        setupView()
    }
    
    convenience init(colors: any Colors, icons: any Icons) {
        self.init(frame: .zero, colors: colors, icons: icons)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
extension EditorView {
    private func setupView() {
        backgroundColor = colors.interface.accent
    }
}
