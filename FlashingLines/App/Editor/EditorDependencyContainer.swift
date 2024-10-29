//
//  EditorDependencyContainer.swift
//  28.10.2024
//

import UIKit

final class EditorDependencyContainer {
    
    // MARK: Private Properties
    private let colors: any Colors
    private let icons: any Icons
    private let layout: any Layout
    private let images: any Images
    private let windowScene: UIWindowScene
    
    // MARK: Initializers
    init(windowScene: UIWindowScene) {
        self.colors = DefaultColors()
        self.icons = DefaultIcons()
        self.layout = DefaultLayout()
        self.images = DefaultImages()
        self.windowScene = windowScene
    }
    
    // MARK: Internal Methods
    func makeEditorViewController() -> UIViewController {
        EditorViewController(colors: colors, icons: icons, layout: layout, images: images)
    }
}
