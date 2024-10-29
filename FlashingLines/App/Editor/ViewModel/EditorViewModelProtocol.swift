//
//  EditorViewModelProtocol.swift
//  29.10.2024
//

import Combine
import Foundation

protocol EditorViewModelProtocol {
    var statePublisher: any Publisher<EditorCommandPipe, Never> { get }
    func setupBindings(_ bindings: EditorBindings) -> any Sequence<AnyCancellable>
}
