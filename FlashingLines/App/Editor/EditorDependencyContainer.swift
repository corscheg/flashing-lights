//
//  EditorDependencyContainer.swift
//  28.10.2024
//

import UIKit

final class EditorDependencyContainer {
    
    // MARK: Private Properties
    private let colors: any Colors
    private let palette: any PaletteColors
    private let icons: any Icons
    private let layout: any Layout
    private let images: any Images
    private let animationParameters: any AnimationParameters
    private let windowScene: UIWindowScene
    private let defaultColorSet: ColorSet
    
    // MARK: Initializers
    init(windowScene: UIWindowScene) {
        self.colors = DefaultColors()
        self.palette = DefaultPaletteColors()
        self.icons = DefaultIcons()
        self.layout = DefaultLayout()
        self.images = DefaultImages()
        self.animationParameters = DefaultAnimationParameters()
        self.windowScene = windowScene
        self.defaultColorSet = ColorSet(
            color1: palette.white,
            color2: palette.red,
            color3: palette.black,
            color4: palette.darkBlue
        )
    }
    
    // MARK: Internal Methods
    func makeEditorViewController() -> UIViewController {
        EditorViewController(
            viewModel: makeEditorViewModel(),
            colors: colors,
            icons: icons,
            layout: layout,
            images: images,
            animationParameters: animationParameters,
            screen: windowScene.screen
        )
    }
}

// MARK: - Private Methods
extension EditorDependencyContainer {
    func makeEditorViewModel() -> some EditorViewModelProtocol<ArrayStack<UIImage>> {
        EditorViewModel<UIImage>(colorSet: defaultColorSet)
    }
}
