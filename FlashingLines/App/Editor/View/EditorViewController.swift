//
//  EditorViewController.swift
//  28.10.2024
//

import UIKit

final class EditorViewController<ViewModel: EditorViewModelProtocol>: UIViewController {
    
    // MARK: Private Properties
    private let viewModel: ViewModel
    private let colors: any Colors
    private let icons: any Icons
    private let layout: any Layout
    private let images: any Images
    private let screen: UIScreen
    private let device: MTLDevice
    private let metalFunctionName: String
    
    // MARK: Visual Components
    private lazy var editorView: EditorView<ViewModel> = EditorView(
        viewModel: viewModel,
        colors: colors,
        icons: icons,
        layout: layout,
        images: images,
        screen: screen,
        device: device,
        metalFunctionName: metalFunctionName
    )
    
    // MARK: Initializers
    init(
        viewModel: ViewModel,
        colors: any Colors,
        icons: any Icons,
        layout: any Layout,
        images: any Images,
        screen: UIScreen,
        device: MTLDevice,
        metalFunctionName: String
    ) {
        self.viewModel = viewModel
        self.colors = colors
        self.icons = icons
        self.layout = layout
        self.images = images
        self.screen = screen
        self.device = device
        self.metalFunctionName = metalFunctionName
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    override func loadView() {
        view = editorView
    }
}

