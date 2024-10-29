//
//  SceneDelegate.swift
//  29.10.2024
//

import UIKit

final class SceneDelegate: UIResponder, UISceneDelegate {
    
    // MARK: Private Properties
    var window: UIWindow?
    private var container: EditorDependencyContainer?
    
    // MARK: UISceneDelegate
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let dependencyContainer = EditorDependencyContainer(windowScene: windowScene)
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.rootViewController = dependencyContainer.makeEditorViewController()
        self.container = dependencyContainer
        window.makeKeyAndVisible()
    }
}
