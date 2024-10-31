//
//  EditorViewController.swift
//  28.10.2024
//

import UIKit

final class EditorViewController<ViewModel: EditorViewModelProtocol>: UIViewController where ViewModel.Layer == UIImage {
    
    // MARK: Private Properties
    private let viewModel: ViewModel
    private let colors: any Colors
    private let icons: any Icons
    private let layout: any Layout
    private let images: any Images
    private let animationParameters: any AnimationParameters
    private let screen: UIScreen
    
    // MARK: Visual Components
    private lazy var editorView: EditorView<ViewModel, ViewModel.Playable> = EditorView(
        viewModel: viewModel,
        colors: colors,
        icons: icons,
        layout: layout,
        images: images,
        animationParameters: animationParameters,
        screen: screen
    )
    
    // MARK: Initializers
    init(
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

