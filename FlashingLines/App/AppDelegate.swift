//
//  AppDelegate.swift
//  28.10.2024
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Internal Properties
    var window: UIWindow?
    
    // MARK: Private Properties
    private let container: EditorDependencyContainer = EditorDependencyContainer()
    
    // MARK: UIApplicationDelegate
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow()
        let viewController = container.makeEditorViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        return true
    }
}

