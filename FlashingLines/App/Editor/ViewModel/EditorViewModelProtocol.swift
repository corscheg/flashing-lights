//
//  EditorViewModelProtocol.swift
//  29.10.2024
//

import Combine
import Foundation

protocol EditorViewModelProtocol<Playable> {
    associatedtype Layer
    associatedtype Playable: Collection where Playable.Element == Layer
    associatedtype State: EditorInterfaceStateProtocol
    var commandPublisher: any Publisher<EditorCommandPipe<Layer, Playable>, Never> { get }
    var state: State { get }
    var statePublisher: any Publisher<State, Never> { get }
    func setupBindings(_ bindings: EditorBindings<Layer>) -> any Sequence<AnyCancellable>
}
