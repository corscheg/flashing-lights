//
//  EditorViewController.swift
//  28.10.2024
//

import UIKit

final class EditorViewController: UIViewController {
    
    // MARK: Private Properties
    private let colors: any Colors
    private let icons: any Icons
    
    // MARK: Visual Components
    private lazy var editorView: EditorView = EditorView(colors: colors, icons: icons)
    
    // MARK: Initializers
    init(colors: any Colors, icons: any Icons) {
        self.colors = colors
        self.icons = icons
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

