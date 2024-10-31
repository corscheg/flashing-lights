//
//  ColorSelectorView.swift
//  31.10.2024
//

import Combine
import UIKit

final class ColorSelectorView: UIView {
    
    // MARK: Internal Properties
    let bindings: Bindings = .init()
    
    // MARK: Private Properties
    private let colorSet: ColorSet
    private let colors: any InterfaceColors
    private let layout: any Layout
    private let icons: any ToolbarIcons
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Visual Components
    private lazy var blurEffectView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .extraLight)
        let view = UIVisualEffectView(effect: effect)
        
        return view
    }()
    
    private lazy var selectorPanelView: PanelControlView<SelectorAction, SelectorPanelFactory> = {
        let panelView = PanelControlView<SelectorAction, SelectorPanelFactory>(
            colors: colors,
            contentFactory: SelectorPanelFactory(
                colors: colors,
                layout: layout,
                icons: icons,
                colorSet: colorSet
            ),
            layout: layout,
            buttonSize: .regular,
            spacing: \.regular
        )
        
        panelView.actionPublisher.sink { [bindings, colorSet] action in
            switch action {
            case .palette:
                bindings.onPaletteSelect.send()
            case .color1:
                bindings.onColorSelect.send(colorSet.color1)
            case .color2:
                bindings.onColorSelect.send(colorSet.color2)
            case .color3:
                bindings.onColorSelect.send(colorSet.color3)
            case .color4:
                bindings.onColorSelect.send(colorSet.color4)
            }
        }
        .store(in: &cancellables)
        
        return panelView
    }()
    
    // MARK: Initializers
    init(frame: CGRect, colorSet: ColorSet, colors: any InterfaceColors, layout: any Layout, icons: any ToolbarIcons) {
        self.colorSet = colorSet
        self.colors = colors
        self.layout = layout
        self.icons = icons
        super.init(frame: frame)
        
        addSubviews()
    }
    
    convenience init(colorSet: ColorSet, colors: any InterfaceColors, layout: any Layout, icons: any ToolbarIcons) {
        self.init(frame: .zero, colorSet: colorSet, colors: colors, layout: layout, icons: icons)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIView
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let panelSize = selectorPanelView.sizeThatFits(
            CGSize(
                width: size.width - layout.spacings.regular * 2.0,
                height: size.height - layout.spacings.regular * 2.0
            )
        )
        
        return CGSize(
            width: panelSize.width + layout.spacings.regular * 2.0,
            height: panelSize.height + layout.spacings.regular * 2.0
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        blurEffectView.frame = bounds
        selectorPanelView.frame = blurEffectView.bounds.insetBy(
            dx: layout.spacings.regular,
            dy: layout.spacings.regular
        )
    }
}

// MARK: - Bindings
extension ColorSelectorView {
    struct Bindings {
        let onPaletteSelect: PassthroughSubject<Void, Never> = .init()
        let onColorSelect: PassthroughSubject<Color, Never> = .init()
    }
}

// MARK: - Private Methods
extension ColorSelectorView {
    private func setupView() {
        layer.cornerRadius = layout.cornerRadiuses.small
        layer.cornerCurve = .continuous
        layer.borderColor = colors.prominentBorder.cgColor
        layer.borderWidth = layout.borders.thinRegular
        clipsToBounds = true
    }
    
    private func addSubviews() {
        addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(selectorPanelView)
    }
}

// MARK: - SelectorPanelFactory
extension ColorSelectorView {
    private struct SelectorPanelFactory {
        
        private let colors: any InterfaceColors
        private let layout: any Layout
        private let icons: any ToolbarIcons
        private let colorSet: ColorSet
        
        init(colors: any InterfaceColors, layout: any Layout, icons: any ToolbarIcons, colorSet: ColorSet) {
            self.colors = colors
            self.layout = layout
            self.icons = icons
            self.colorSet = colorSet
        }
        
        var palette: UIControl {
            ToolButton(colors: colors, sizes: layout.sizes, size: .regular, image: icons.palette)
        }
        
        var color1: UIControl {
            ColorButton(layout: layout, colors: colors, initialColor: UIColor(color: colorSet.color1))
        }
        
        var color2: UIControl {
            ColorButton(layout: layout, colors: colors, initialColor: UIColor(color: colorSet.color2))
        }
        
        var color3: UIControl {
            ColorButton(layout: layout, colors: colors, initialColor: UIColor(color: colorSet.color3))
        }
        
        var color4: UIControl {
            ColorButton(layout: layout, colors: colors, initialColor: UIColor(color: colorSet.color4))
        }
    }
}

// MARK: - SelectorAction
extension ColorSelectorView {
    private enum SelectorAction: PanelControlAction {
        case palette
        case color1
        case color2
        case color3
        case color4
        
        var contentKeyPath: KeyPath<SelectorPanelFactory, UIControl> {
            switch self {
            case .palette:
                \.palette
            case .color1:
                \.color1
            case .color2:
                \.color2
            case .color3:
                \.color3
            case .color4:
                \.color4
            }
        }
    }
}
