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
    private lazy var panelView: PanelControlView<PanelAction, PanelFactory> = {
        let control = PanelControlView<PanelAction, PanelFactory>(
            colors: colors.interface,
            contentFactory: PanelFactory(
                interfaceColors: colors.interface,
                layout: layout,
                images: icons
            ),
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
            case .colors:
                bindings.onColorsTap.send()
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
    
    // MARK: Internal Methods
    func setPencilState(_ state: EditorInterfaceState.ButtonState) {
        panelView.setButton(.pencil, enabled: state.isEnabled)
        panelView.setButton(.pencil, selected: state.isSelected)
    }
    
    func setBrushState(_ state: EditorInterfaceState.ButtonState) {
        panelView.setButton(.brush, enabled: state.isEnabled)
        panelView.setButton(.brush, selected: state.isSelected)
    }
    
    func setEraseState(_ state: EditorInterfaceState.ButtonState) {
        panelView.setButton(.eraser, enabled: state.isEnabled)
        panelView.setButton(.eraser, selected: state.isSelected)
    }
    
    func setShapesState(_ state: EditorInterfaceState.ButtonState) {
        panelView.setButton(.shape, enabled: state.isEnabled)
        panelView.setButton(.shape, selected: state.isSelected)
    }
    
    func setColorsState(_ state: EditorInterfaceState.ButtonState) {
        panelView.setButton(.colors, enabled: state.isEnabled)
        panelView.setButton(.colors, selected: state.isSelected)
    }
}

// MARK: - Bindings
extension ToolbarView {
    struct Bindings {
        let onPencilTap: PassthroughSubject<Void, Never> = .init()
        let onBrushTap: PassthroughSubject<Void, Never> = .init()
        let onEraseTap: PassthroughSubject<Void, Never> = .init()
        let onShapeTap: PassthroughSubject<Void, Never> = .init()
        let onColorsTap: PassthroughSubject<Void, Never> = .init()
    }
}

// MARK: - Private Methods
extension ToolbarView {
    private func addSubviews() {
        addSubview(panelView)
    }
}

// MARK: - PanelFactory
extension ToolbarView {
    private struct PanelFactory {
        
        private let interfaceColors: any InterfaceColors
        private let layout: any Layout
        private let images: any ToolbarIcons
        
        init(interfaceColors: any InterfaceColors, layout: any Layout, images: any ToolbarIcons) {
            self.interfaceColors = interfaceColors
            self.layout = layout
            self.images = images
        }
        
        var pencil: UIControl {
            ToolButton(colors: interfaceColors, sizes: layout.sizes, size: .regular, image: images.pencil)
        }
        
        var brush: UIControl {
            ToolButton(colors: interfaceColors, sizes: layout.sizes, size: .regular, image: images.brush)
        }
        
        var erase: UIControl {
            ToolButton(colors: interfaceColors, sizes: layout.sizes, size: .regular, image: images.erase)
        }
        
        var instruments: UIControl {
            ToolButton(colors: interfaceColors, sizes: layout.sizes, size: .regular, image: .instruments)
        }
        
        var colors: UIControl {
            ColorButton(layout: layout, colors: interfaceColors)
        }
    }
}

// MARK: - PanelAction
extension ToolbarView {
    private enum PanelAction: PanelControlAction {
        
        case pencil
        case brush
        case eraser
        case shape
        case colors
        
        var contentKeyPath: KeyPath<PanelFactory, UIControl> {
            switch self {
            case .pencil:
                \.pencil
            case .brush:
                \.brush
            case .eraser:
                \.erase
            case .shape:
                \.instruments
            case .colors:
                \.colors
            }
        }
    }
}
