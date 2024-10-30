//
//  NavbarView.swift
//  28.10.2024
//

import Combine
import UIKit

final class NavbarView: UIView {
    
    // MARK: Internal Properties
    let bindings: Bindings = .init()
    
    // MARK: Private Properties
    private let colors: any InterfaceColors
    private let icons: any NavbarIcons
    private let layout: any Layout
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Visual Components
    private lazy var undoControl: PanelControlView<UndoAction, any NavbarIcons> = {
        let control = PanelControlView<UndoAction, any NavbarIcons>(
            colors: colors,
            icons: icons,
            layout: layout,
            buttonSize: .small,
            spacing: \.small
        )
        
        control.actionPublisher.sink { [bindings] action in
            switch action {
            case .undo:
                bindings.onUndoTap.send()
            case .redo:
                bindings.onRedoTap.send()
            }
        }
        .store(in: &cancellables)
        
        return control
    }()
    
    private lazy var layerControl: PanelControlView<LayerAction, any NavbarIcons> = {
        let control = PanelControlView<LayerAction, any NavbarIcons>(
            colors: colors,
            icons: icons,
            layout: layout,
            buttonSize: .regular,
            spacing: \.regular
        )
        
        control.actionPublisher.sink { [bindings] action in
            switch action {
            case .delete:
                bindings.onDeleteTap.send()
            case .addLayer:
                bindings.onNewLayerTap.send()
            case .showLayers:
                bindings.onShowLayersTap.send()
            }
        }
        .store(in: &cancellables)
        
        return control
    }()
    
    private lazy var playbackControl: PanelControlView<PlaybackAction, any NavbarIcons> = {
        let control = PanelControlView<PlaybackAction, any NavbarIcons>(
            colors: colors,
            icons: icons,
            layout: layout,
            buttonSize: .regular,
            spacing: \.regular
        )
        
        control.actionPublisher.sink { [bindings] action in
            switch action {
            case .pause:
                bindings.onPauseTap.send()
            case .play:
                bindings.onPlayTap.send()
            }
        }
        .store(in: &cancellables)
        
        return control
    }()
    
    // MARK: Initializers
    init(frame: CGRect, colors: any InterfaceColors, icons: any NavbarIcons, layout: any Layout) {
        self.colors = colors
        self.icons = icons
        self.layout = layout
        super.init(frame: frame)
        
        addSubviews()
    }
    
    convenience init(colors: any InterfaceColors, icons: any NavbarIcons, layout: any Layout) {
        self.init(frame: .zero, colors: colors, icons: icons, layout: layout)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIView
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let spacing = layout.spacings.regular
        let undoControlSize = undoControl.sizeThatFits(size)
        let layerControlSize = layerControl.sizeThatFits(
            CGSize(
                width: size.width - undoControlSize.width - spacing,
                height: size.height
            )
        )
        let playbackControlSize = playbackControl.sizeThatFits(
            CGSize(
                width: size.width - undoControlSize.width - layerControlSize.width - spacing * 2,
                height: size.height
            )
        )
        
        let width = max(size.width, undoControlSize.width + layerControlSize.width + playbackControlSize.width + spacing * 2)
        let height = max(undoControlSize.height, layerControlSize.height, playbackControlSize.height)
        return CGSize(width: width, height: height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let spacing = layout.spacings.regular
        
        let undoControlSize = undoControl.sizeThatFits(bounds.size)
        let undoControlOrigin = CGPoint(x: bounds.minX, y: bounds.midY - undoControlSize.height / 2)
        undoControl.frame = CGRect(origin: undoControlOrigin, size: undoControlSize)
        
        let playbackControlSize = playbackControl.sizeThatFits(
            CGSize(
                width: bounds.width - undoControlSize.width - spacing,
                height: bounds.height
            )
        )
        
        let playbackControlOrigin = CGPoint(
            x: bounds.maxX - playbackControlSize.width,
            y: bounds.midY - playbackControlSize.height / 2
        )
        
        playbackControl.frame = CGRect(origin: playbackControlOrigin, size: playbackControlSize)
        
        let layerControlSize = layerControl.sizeThatFits(
            CGSize(
                width: bounds.width - undoControlSize.width - playbackControlSize.width - spacing * 2,
                height: bounds.height
            )
        )
        
        let layerControlOrigin = CGPoint(
            x: (playbackControl.frame.minX - undoControl.frame.maxX) / 2 + undoControl.frame.maxX - layerControlSize.width / 2,
            y: bounds.midY - layerControlSize.height / 2
        )
        
        layerControl.frame = CGRect(origin: layerControlOrigin, size: layerControlSize)
    }
    
    // MARK: Internal Methods
    func setUndoState(_ state: EditorInterfaceState.ButtonState) {
        undoControl.setButton(.undo, enabled: state.isEnabled)
        undoControl.setButton(.undo, selected: state.isSelected)
    }
    
    func setRedoState(_ state: EditorInterfaceState.ButtonState) {
        undoControl.setButton(.redo, enabled: state.isEnabled)
        undoControl.setButton(.redo, selected: state.isSelected)
    }
    
    func setDeleteState(_ state: EditorInterfaceState.ButtonState) {
        layerControl.setButton(.delete, enabled: state.isEnabled)
        layerControl.setButton(.delete, selected: state.isSelected)
    }
    
    func setNewLayerState(_ state: EditorInterfaceState.ButtonState) {
        layerControl.setButton(.addLayer, enabled: state.isEnabled)
        layerControl.setButton(.addLayer, selected: state.isSelected)
    }
    
    func setShowLayersState(_ state: EditorInterfaceState.ButtonState) {
        layerControl.setButton(.showLayers, enabled: state.isEnabled)
        layerControl.setButton(.showLayers, selected: state.isSelected)
    }
    
    func setPlayState(_ state: EditorInterfaceState.ButtonState) {
        playbackControl.setButton(.play, enabled: state.isEnabled)
        playbackControl.setButton(.play, selected: state.isSelected)
    }
    
    func setPauseState(_ state: EditorInterfaceState.ButtonState) {
        playbackControl.setButton(.pause, enabled: state.isEnabled)
        playbackControl.setButton(.pause, selected: state.isSelected)
    }
}

// MARK: - Bindings
extension NavbarView {
    struct Bindings {
        let onUndoTap: PassthroughSubject<Void, Never> = .init()
        let onRedoTap: PassthroughSubject<Void, Never> = .init()
        let onDeleteTap: PassthroughSubject<Void, Never> = .init()
        let onNewLayerTap: PassthroughSubject<Void, Never> = .init()
        let onShowLayersTap: PassthroughSubject<Void, Never> = .init()
        let onPauseTap: PassthroughSubject<Void, Never> = .init()
        let onPlayTap: PassthroughSubject<Void, Never> = .init()
    }
}

// MARK: - Private Methods
extension NavbarView {
    private func addSubviews() {
        addSubview(undoControl)
        addSubview(layerControl)
        addSubview(playbackControl)
    }
}

// MARK: - UndoAction
extension NavbarView {
    private enum UndoAction: PanelControlAction {
        case undo
        case redo
        
        var image: KeyPath<any NavbarIcons, UIImage> {
            switch self {
            case .undo:
                \.undo
            case .redo:
                \.redo
            }
        }
    }
}

// MARK: - LayerAction
extension NavbarView {
    private enum LayerAction: PanelControlAction {
        case delete
        case addLayer
        case showLayers
        
        var image: KeyPath<any NavbarIcons, UIImage> {
            switch self {
            case .delete:
                \.bin
            case .addLayer:
                \.newFile
            case .showLayers:
                \.layers
            }
        }
    }
}

// MARK: - PlaybackAction
extension NavbarView {
    private enum PlaybackAction: PanelControlAction {
        case play
        case pause
        
        var image: KeyPath<any NavbarIcons, UIImage> {
            switch self {
            case .play:
                \.play
            case .pause:
                \.pause
            }
        }
    }
}
