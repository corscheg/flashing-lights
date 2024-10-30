//
//  EditorView.swift
//  28.10.2024
//

import Combine
import UIKit

final class EditorView<ViewModel: EditorViewModelProtocol>: UIView where ViewModel.Layer == UIImage {
    // MARK: Private Properties
    private let viewModel: ViewModel
    private let colors: any Colors
    private let icons: any Icons
    private let layout: any Layout
    private let images: any Images
    private let screen: UIScreen
    private let bindings: EditorBindings<UIImage> = .init()
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Visual Components
    private lazy var navbarView: NavbarView = {
        let view = NavbarView(colors: colors.interface, icons: icons.navbar, layout: layout)
        
        view.bindings.onUndoTap.subscribe(bindings.onUndoTap).store(in: &cancellables)
        view.bindings.onRedoTap.subscribe(bindings.onRedoTap).store(in: &cancellables)
        view.bindings.onDeleteTap.subscribe(bindings.onDeleteTap).store(in: &cancellables)
        view.bindings.onNewLayerTap.subscribe(bindings.onNewLayerTap).store(in: &cancellables)
        view.bindings.onShowLayersTap.subscribe(bindings.onShowLayersTap).store(in: &cancellables)
        view.bindings.onPlayTap.subscribe(bindings.onPlayTap).store(in: &cancellables)
        view.bindings.onPauseTap.subscribe(bindings.onPauseTap).store(in: &cancellables)
        
        return view
    }()
    
    private lazy var canvasView: CanvasView = {
        let view = CanvasView(cornerRadiuses: layout.cornerRadiuses, images: images, opacities: colors.opacities, screen: screen)
        
        view.eventPublisher.subscribe(bindings.onTouchEvent).store(in: &cancellables)
        
        return view
    }()
    
    private lazy var toolbarView: ToolbarView = {
        let view = ToolbarView(colors: colors, icons: icons.toolbar, layout: layout)
        
        view.bindings.onPencilTap.subscribe(bindings.onPencilTap).store(in: &cancellables)
        view.bindings.onBrushTap.subscribe(bindings.onBrushTap).store(in: &cancellables)
        view.bindings.onEraseTap.subscribe(bindings.onEraseTap).store(in: &cancellables)
        view.bindings.onShapeTap.subscribe(bindings.onShapesTap).store(in: &cancellables)
        
        return view
    }()
    
    // MARK: Initializers
    init(
        frame: CGRect,
        viewModel: ViewModel,
        colors: any Colors,
        icons: any Icons,
        layout: any Layout,
        images: any Images,
        screen: UIScreen
    ) {
        self.viewModel = viewModel
        self.colors = colors
        self.icons = icons
        self.layout = layout
        self.images = images
        self.screen = screen
        
        super.init(frame: frame)
        
        setupView()
        addSubviews()
        setupBindings()
    }
    
    convenience init(
        viewModel: ViewModel,
        colors: any Colors,
        icons: any Icons,
        layout: any Layout,
        images: any Images,
        screen: UIScreen
    ) {
        self.init(
            frame: .zero,
            viewModel: viewModel,
            colors: colors,
            icons: icons,
            layout: layout,
            images: images,
            screen: screen
        )
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
    
    private func setupBindings() {
        viewModel.setupBindings(bindings).forEach { $0.store(in: &cancellables) }
        
        viewModel.commandPublisher
            .sink { [weak self] state in
                guard let `self` else { return }
                
                for command in state.commands {
                    switch command {
                    case .begin(location: let location):
                        canvasView.startDrawing(at: location)
                    case .continue(location: let location, width: let width, color: let color):
                        canvasView.continueDrawing(to: location, brushWidth: width, color: UIColor(color: color).cgColor)
                    case .end(location: let location, width: let width, color: let color):
                        canvasView.endDrawing(at: location, brushWidth: width, color: UIColor(color: color).cgColor)
                    case .movePaintingToUndo:
                        canvasView.movePaintingToUndo()
                    case .moveUndoToDrawn:
                        canvasView.moveUndoToDrawn()
                    case .undo:
                        canvasView.performUndo()
                    case .redo:
                        canvasView.performRedo()
                    case .takeLayer:
                        guard let image = canvasView.takeCurrentImage() else { return }
                        bindings.onLayerTaken.send(image)
                    case .setAssistLayer(let image):
                        canvasView.setAssistImage(image)
                    }
                }
            }
            .store(in: &cancellables)
        
        viewModel.statePublisher
            .sink { [weak self] state in
                guard let `self` else { return }
                navbarView.setUndoState(state.undoButton)
                navbarView.setRedoState(state.redoButton)
            }
            .store(in: &cancellables)
    }
}
