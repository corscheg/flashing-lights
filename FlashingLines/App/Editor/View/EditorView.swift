//
//  EditorView.swift
//  28.10.2024
//

import Combine
import UIKit

final class EditorView<ViewModel: EditorViewModelProtocol, Playable: Collection>: UIView where ViewModel.Layer == UIImage, Playable.Element == UIImage, ViewModel.Playable == Playable {
    // MARK: Private Properties
    private let viewModel: ViewModel
    private let colors: any Colors
    private let icons: any Icons
    private let layout: any Layout
    private let images: any Images
    private let animationParameters: any AnimationParameters
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
        view.bindings.onDuplicateTap.subscribe(bindings.onDuplicateTap).store(in: &cancellables)
        view.bindings.onDeleteAllTap.subscribe(bindings.onDeleteAllTap).store(in: &cancellables)
        
        return view
    }()
    
    private lazy var canvasView: CanvasView = {
        let view = CanvasView<Playable>(
            cornerRadiuses: layout.cornerRadiuses,
            images: images,
            opacities: colors.interface.opacities,
            screen: screen
        )
        
        view.eventPublisher.subscribe(bindings.onTouchEvent).store(in: &cancellables)
        
        return view
    }()
    
    private lazy var toolbarView: ToolbarView = {
        let view = ToolbarView(colors: colors, icons: icons.toolbar, layout: layout)
        
        view.bindings.onPencilTap.subscribe(bindings.onPencilTap).store(in: &cancellables)
        view.bindings.onBrushTap.subscribe(bindings.onBrushTap).store(in: &cancellables)
        view.bindings.onEraseTap.subscribe(bindings.onEraseTap).store(in: &cancellables)
        view.bindings.onShapeTap.subscribe(bindings.onShapesTap).store(in: &cancellables)
        view.bindings.onColorsTap.subscribe(bindings.onColorsTap).store(in: &cancellables)
        
        return view
    }()
    
    private lazy var colorSelectorView: ColorSelectorView = {
        let view = ColorSelectorView(
            colorSet: viewModel.state.initialColorSet,
            colors: colors.interface,
            layout: layout,
            icons: icons.toolbar
        )
        
        view.bindings.onColorSelect.subscribe(bindings.onColorSelect).store(in: &cancellables)
        
        view.alpha = viewModel.state.isColorPickerShown ? 1.0 : .zero
        
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
        animationParameters: any AnimationParameters,
        screen: UIScreen
    ) {
        self.viewModel = viewModel
        self.colors = colors
        self.icons = icons
        self.layout = layout
        self.images = images
        self.animationParameters = animationParameters
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
        animationParameters: any AnimationParameters,
        screen: UIScreen
    ) {
        self.init(
            frame: .zero,
            viewModel: viewModel,
            colors: colors,
            icons: icons,
            layout: layout,
            images: images,
            animationParameters: animationParameters,
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
        
        let colorPickerSize = colorSelectorView.sizeThatFits(spacedRect.size)
        let colorPickerOrigin = CGPoint(
            x: spacedRect.midX - colorPickerSize.width / 2,
            y: toolbarView.frame.minY - colorPickerSize.height - layout.spacings.regular
        )
        
        colorSelectorView.frame = CGRect(origin: colorPickerOrigin, size: colorPickerSize)
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
        addSubview(colorSelectorView)
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
                    case .takeLayer(let duplicate):
                        guard let image = canvasView.takeCurrentImage() else { return }
                        bindings.onLayerTaken.send((layer: image, duplicate: duplicate))
                    case .setAssistLayer(let image):
                        canvasView.setAssistImage(image)
                    case .clearCanvas:
                        canvasView.clearPainting()
                    case .setDrawn(let image):
                        canvasView.setDrawnImage(image)
                    case .play(let playable):
                        canvasView.startPlaying(playable, at: 10)
                    case .stop:
                        canvasView.stopPlaying()
                    case .beginErase(location: let location):
                        canvasView.startErase(at: location)
                    case .continueErase(location: let location, width: let width):
                        canvasView.continueErase(to: location, width: width)
                    case .endErase(location: let location, width: let width):
                        canvasView.endErase(at: location, width: width)
                    case .commitErase:
                        canvasView.commitErase()
                    case .undoErase:
                        canvasView.undoErase()
                    case .redoErase:
                        canvasView.redoErase()
                    }
                }
            }
            .store(in: &cancellables)
        
        viewModel.statePublisher
            .eraseToAnyPublisher()
            .removeDuplicates()
            .sink { [weak self] state in
                guard let `self` else { return }
                navbarView.setUndoState(state.undoButton)
                navbarView.setRedoState(state.redoButton)
                navbarView.setDeleteState(state.deleteButton)
                navbarView.setNewLayerState(state.newLayerButton)
                navbarView.setShowLayersState(state.showLayersButton)
                navbarView.setPlayState(state.playButton)
                navbarView.setPauseState(state.pauseButton)
                navbarView.setDuplicateState(state.duplicateButton)
                navbarView.setDeleteAllState(state.deleteAllButton)
                toolbarView.setPencilState(state.pencilButton)
                toolbarView.setBrushState(state.brushButton)
                toolbarView.setEraseState(state.eraseButton)
                toolbarView.setShapesState(state.shapesButton)
                toolbarView.setColorsState(state.colorsButton)
                
                setColorPicker(hidden: !state.isColorPickerShown)
                toolbarView.setColor(state.selectedColor)
            }
            .store(in: &cancellables)
    }
    
    private func setColorPicker(hidden: Bool) {
        let newAlpha: CGFloat = hidden ? 0 : 1
        
        UIView.animate(withDuration: animationParameters.duration) {
            self.colorSelectorView.alpha = newAlpha
        }
    }
}
