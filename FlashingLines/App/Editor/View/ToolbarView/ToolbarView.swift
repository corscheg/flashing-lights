//
//  ToolbarView.swift
//  28.10.2024
//

import Combine
import UIKit

final class ToolbarView: UIView {
    
    // MARK: Internal Properties
    let bindings: Bindings = .init()
    
    // MARK: Private Properties
    private let colors: any Colors
    private let icons: any ToolbarIcons
    private let layout: any Layout
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Visual Components
    private lazy var panelView: PanelControlView<PanelAction, any ToolbarIcons> = {
        let control = PanelControlView<PanelAction, any ToolbarIcons>(
            colors: colors.interface,
            icons: icons,
            layout: layout,
            buttonSize: .regular,
            spacing: \.regular
        )
        
        control.actionPublisher.sink { [bindings] action in
            switch action {
            case .pencil:
                bindings.onPencilTap.send()
            case .brush:
                bindings.onBrushTap.send()
            case .eraser:
                bindings.onEraseTap.send()
            case .shape:
                bindings.onShapeTap.send()
            }
        }
        .store(in: &cancellables)
        
        return control
    }()
    
    // MARK: Initializers
    init(frame: CGRect, colors: any Colors, icons: any ToolbarIcons, layout: any Layout) {
        self.colors = colors
        self.icons = icons
        self.layout = layout
        super.init(frame: frame)
        
        addSubviews()
    }
    
    convenience init(colors: any Colors, icons: any ToolbarIcons, layout: any Layout) {
        self.init(frame: .zero, colors: colors, icons: icons, layout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIView
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let panelSize = panelView.sizeThatFits(size)
        return CGSize(width: max(size.width, panelSize.width), height: panelSize.height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let panelSize = panelView.sizeThatFits(bounds.size)
        let panelOrigin = CGPoint(x: bounds.midX - panelSize.width / 2, y: bounds.midY - panelSize.height / 2)
        panelView.frame = CGRect(origin: panelOrigin, size: panelSize)
    }
}

// MARK: - Bindings
extension ToolbarView {
    struct Bindings {
        let onPencilTap: PassthroughSubject<Void, Never> = .init()
        let onBrushTap: PassthroughSubject<Void, Never> = .init()
        let onEraseTap: PassthroughSubject<Void, Never> = .init()
        let onShapeTap: PassthroughSubject<Void, Never> = .init()
    }
}

// MARK: - Private Methods
extension ToolbarView {
    private func addSubviews() {
        addSubview(panelView)
    }
}

// MARK: - PanelAction
extension ToolbarView {
    private enum PanelAction: PanelControlAction {
        case pencil
        case brush
        case eraser
        case shape
        
        var image: KeyPath<any ToolbarIcons, UIImage> {
            switch self {
            case .pencil:
                \.pencil
            case .brush:
                \.brush
            case .eraser:
                \.erase
            case .shape:
                \.instruments
            }
        }
    }
}
