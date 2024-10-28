//
//  EditorView.swift
//  28.10.2024
//

import UIKit

final class EditorView: UIView {
    // MARK: Private Properties
    private let colors: any Colors
    private let icons: any Icons
    private let layout: any Layout
    private let images: any Images
    
    // MARK: Visual Components
    private lazy var navbarView: NavbarView = {
        let view = NavbarView(colors: colors.interface, icons: icons.navbar, layout: layout)
        
        return view
    }()
    
    private lazy var canvasView: CanvasView = {
        let view = CanvasView(cornerRadiuses: layout.cornerRadiuses, images: images)
        
        return view
    }()
    
    private lazy var toolbarView: ToolbarView = {
        let view = ToolbarView(colors: colors, icons: icons.toolbar, layout: layout)
        
        return view
    }()
    
    // MARK: Initializers
    init(frame: CGRect, colors: any Colors, icons: any Icons, layout: any Layout, images: any Images) {
        self.colors = colors
        self.icons = icons
        self.layout = layout
        self.images = images
        
        super.init(frame: frame)
        
        setupView()
        addSubviews()
    }
    
    convenience init(colors: any Colors, icons: any Icons, layout: any Layout, images: any Images) {
        self.init(frame: .zero, colors: colors, icons: icons, layout: layout, images: images)
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
        
        let margin = layout.spacings.margin
        let safeRect = bounds.inset(by: safeAreaInsets)
        let spacedRect = safeRect.inset(by: UIEdgeInsets(top: margin, left: margin, bottom: .zero, right: margin))
        
        let navbarSize = navbarView.sizeThatFits(spacedRect.size)
        let navbarOrigin = spacedRect.origin
        navbarView.frame = CGRect(origin: navbarOrigin, size: navbarSize)
        
        let toolbarSize = toolbarView.sizeThatFits(
            CGSize(
                width: spacedRect.width,
                height: spacedRect.height - navbarView.frame.height - layout.spacings.largeVertical
            )
        )
        
        let toolbarOrigin = CGPoint(x: spacedRect.minX, y: spacedRect.maxY - toolbarSize.height)
        toolbarView.frame = CGRect(origin: toolbarOrigin, size: toolbarSize)
        
        let viewUsedHeight = navbarView.frame.height + toolbarView.frame.height
        let spacingUsedHeight = layout.spacings.largeVertical + layout.spacings.moderateVertical
        let usedHeight = viewUsedHeight + spacingUsedHeight
        let canvasSize = canvasView.sizeThatFits(
            CGSize(
                width: spacedRect.width,
                height: spacedRect.height - usedHeight
            )
        )
        
        let canvasOrigin = CGPoint(x: spacedRect.minX, y: navbarView.frame.maxY + layout.spacings.largeVertical)
        canvasView.frame = CGRect(origin: canvasOrigin, size: canvasSize)
    }
}

// MARK: - Private Methods
extension EditorView {
    private func setupView() {
        backgroundColor = colors.interface.background
    }
    
    private func addSubviews() {
        addSubview(navbarView)
        addSubview(canvasView)
        addSubview(toolbarView)
    }
}
