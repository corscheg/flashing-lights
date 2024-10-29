//
//  EditorViewModelProtocol.swift
//  29.10.2024
//

import Combine
import Foundation

protocol EditorViewModelProtocol {
    var commandPublisher: any Publisher<EditorCommandPipe, Never> { get }
    var statePublisher: any Publisher<EditorInterfaceState, Never> { get }
    func setupBindings(_ bindings: EditorBindings) -> any Sequence<AnyCancellable>
}
