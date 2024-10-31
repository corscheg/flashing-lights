//
//  PanelControlView.swift
//  28.10.2024
//

import Combine
import UIKit

final class PanelControlView<Action: PanelControlAction, ContentFactory>: UIView where Action.ContentFactory == ContentFactory {
    
    // MARK: Internal Properties
    var actionPublisher: some Publisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    // MARK: Private Properties
    private let colors: any InterfaceColors
    private let contentFactory: ContentFactory
    private let layout: any Layout
    private let buttonSize: ToolButton.Size
    private let spacing: KeyPath<any Spacings, CGFloat>
    private let actionSubject: PassthroughSubject<Action, Never> = PassthroughSubject()
    
    private var buttons: [Action: UIControl] = [:]
    
    // MARK: Initializers
    init(
        frame: CGRect,
        colors: any InterfaceColors,
        contentFactory: ContentFactory,
        layout: any Layout,
        buttonSize: ToolButton.Size,
        spacing: KeyPath<any Spacings, CGFloat>
    ) {
        self.colors = colors
        self.contentFactory = contentFactory
        self.layout = layout
        self.buttonSize = buttonSize
        self.spacing = spacing
        super.init(frame: frame)
        
        setupTools()
    }
    
    convenience init(
        colors: any InterfaceColors,
        contentFactory: ContentFactory,
        layout: any Layout,
        buttonSize: ToolButton.Size,
        spacing: KeyPath<any Spacings, CGFloat>
    ) {
        self.init(
            frame: .zero,
            colors: colors,
            contentFactory: contentFactory,
            layout: layout,
            buttonSize: buttonSize,
            spacing: spacing
        )
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIView
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let maxButtonSize = maxButtonSize(for: size)
        let buttonSizes = Action.allCases.sorted().compactMap { buttons[$0]?.sizeThatFits(maxButtonSize) }
        
        let widthSum = buttonSizes.map(\.width).reduce(0, +)
        return CGSize(
            width: widthSum + layout.spacings[keyPath: spacing] * CGFloat(Action.allCases.count - 1),
            height: buttonSizes.map(\.height).max() ?? 0
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maxButtonSize = maxButtonSize(for: bounds.size)
        
        var currentMaxX: CGFloat = bounds.minX
        let spacing = layout.spacings[keyPath: spacing]
        
        for action in buttons.keys.sorted() {
            guard let button = buttons[action] else { continue }
            let buttonSize = button.sizeThatFits(maxButtonSize)
            let buttonOrigin = CGPoint(x: currentMaxX, y: bounds.minY)
            button.frame = CGRect(origin: buttonOrigin, size: buttonSize)
            currentMaxX += buttonSize.width + spacing
        }
    }
    
    // MARK: Internal Methods
    func setButton(_ action: Action, selected: Bool) {
        buttons[action]?.isSelected = selected
    }
    
    func setButton(_ action: Action, enabled: Bool) {
        buttons[action]?.isEnabled = enabled
    }
    
    func runAction(on action: Action, operation: (UIControl) -> Void) {
        buttons[action].map(operation)
    }
}

// MARK: - Private Methods
extension PanelControlView {
    private func setupTools() {
        for action in Action.allCases {
            let button = contentFactory[keyPath: action.contentKeyPath]
            
            let buttonAction = UIAction { [actionSubject] _ in
                actionSubject.send(action)
            }
            
            button.addAction(buttonAction, for: .touchUpInside)
            addSubview(button)
            buttons[action] = button
        }
    }
    
    private func maxButtonSize(for controlSize: CGSize) -> CGSize {
        let buttonCount: CGFloat = CGFloat(Action.allCases.count)
        let spacing = layout.spacings[keyPath: spacing]
        let maxWidth = (controlSize.width - (spacing * buttonCount - 1)) / buttonCount
        return CGSize(width: maxWidth, height: controlSize.height)
    }
}
