//
//  EditorViewModelProtocol.swift
//  29.10.2024
//

import Combine
import Foundation

protocol EditorViewModelProtocol<Layer> {
    associatedtype Layer
    var commandPublisher: any Publisher<EditorCommandPipe<Layer>, Never> { get }
    var statePublisher: any Publisher<EditorInterfaceState, Never> { get }
    func setupBindings(_ bindings: EditorBindings<Layer>) -> any Sequence<AnyCancellable>
}
