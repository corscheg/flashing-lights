//
//  EditorViewModel.swift
//  29.10.2024
//

import Combine
import Foundation

final class EditorViewModel {
    
    // MARK: Private Properties
    private let commandSubject: PassthroughSubject<EditorCommandPipe, Never> = .init()
    private let stateSubject: CurrentValueSubject<EditorInterfaceState, Never> = .init(.initial)
}

// MARK: - EditorViewModelProtocol
extension EditorViewModel: EditorViewModelProtocol {
    var commandPublisher: any Publisher<EditorCommandPipe, Never> {
        commandSubject.eraseToAnyPublisher()
    }
    
    var statePublisher: any Publisher<EditorInterfaceState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    func setupBindings(_ bindings: EditorBindings) -> any Sequence<AnyCancellable> {
        [
            bindings.onTouchEvent.sink { [commandSubject, stateSubject] event in
                let commandPipe: EditorCommandPipe
                switch event {
                case .began(let location):
                    commandPipe = EditorCommandPipe(commands: [.moveUndoToDrawn, .begin(location: location)])
                    stateSubject.value.undoButton.isEnabled = false
                    stateSubject.value.redoButton.isEnabled = false
                case .moved(let location):
                    commandPipe = EditorCommandPipe(commands: [.continue(location: location, width: 10, color: Color(red: 0, green: 0, blue: 0, alpha: 0xFF))])
                case .ended(let location):
                    commandPipe = EditorCommandPipe(commands: [.end(location: location, width: 10, color: Color(red: 0, green: 0, blue: 0, alpha: 0xFF)), .movePaintingToUndo])
                    stateSubject.value.undoButton.isEnabled = true
                }
                
                commandSubject.send(commandPipe)
            },
            
            bindings.onUndoTap.sink { [commandSubject, stateSubject] in
                commandSubject.send(.init(commands: [.undo]))
                stateSubject.value.undoButton.isEnabled = false
                stateSubject.value.redoButton.isEnabled = true
            },
            
            bindings.onRedoTap.sink { [commandSubject, stateSubject] in
                commandSubject.send(.init(commands: [.redo]))
                stateSubject.value.undoButton.isEnabled = true
                stateSubject.value.redoButton.isEnabled = false
            }
        ]
    }
}
