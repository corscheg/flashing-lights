//
//  EditorViewModel.swift
//  29.10.2024
//

import Combine
import Foundation

final class EditorViewModel {
    
    // MARK: Private Properties
    private let stateSubject: PassthroughSubject<EditorCommandPipe, Never> = .init()
}

// MARK: - EditorViewModelProtocol
extension EditorViewModel: EditorViewModelProtocol {
    var statePublisher: any Publisher<EditorCommandPipe, Never> {
        stateSubject
    }
    
    func setupBindings(_ bindings: EditorBindings) -> any Sequence<AnyCancellable> {
        [
            bindings.onTouchEvent.sink { [stateSubject] event in
                let state = switch event {
                case .began(let location):
                    EditorCommandPipe(commands: [.moveUndoToDrawn, .begin(location: location)])
                case .moved(let location):
                    EditorCommandPipe(commands: [.continue(location: location, width: 10, color: Color(red: 0, green: 0, blue: 0, alpha: 0xFF))])
                case .ended(let location):
                    EditorCommandPipe(commands: [.end(location: location, width: 10, color: Color(red: 0, green: 0, blue: 0, alpha: 0xFF)), .movePaintingToUndo])
                }
                
                stateSubject.send(state)
            }
        ]
    }
}
