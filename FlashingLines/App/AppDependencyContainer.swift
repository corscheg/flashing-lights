//
//  AppDependencyContainer.swift
//  28.10.2024
//

import UIKit

final class AppDependencyContainer {
    
    // MARK: Private Properties
    private let colors: any Colors
    private let icons: any Icons
    
    // MARK: Initializers
    init() {
        self.colors = DefaultColors()
        self.icons = DefaultIcons()
    }
    
    // MARK: Internal Methods
    func makeEditorViewController() -> UIViewController {
        EditorViewController(colors: colors, icons: icons)
    }
}
