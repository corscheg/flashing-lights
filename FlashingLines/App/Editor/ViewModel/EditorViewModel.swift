//
//  EditorViewModel.swift
//  29.10.2024
//

import Combine
import Foundation

final class EditorViewModel<Layer> {
    
    // MARK: Private Properties
    private let commandSubject: PassthroughSubject<EditorCommandPipe<Layer>, Never> = .init()
    private let stateSubject: CurrentValueSubject<EditorInterfaceState, Never> = .init(.initial)
    private var layerStack: ArrayStack<Layer> = []
}

// MARK: - EditorViewModelProtocol
extension EditorViewModel: EditorViewModelProtocol {
    var commandPublisher: any Publisher<EditorCommandPipe<Layer>, Never> {
        commandSubject.eraseToAnyPublisher()
    }
    
    var statePublisher: any Publisher<EditorInterfaceState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    func setupBindings(_ bindings: EditorBindings<Layer>) -> any Sequence<AnyCancellable> {
        [
            bindings.onTouchEvent.sink { [commandSubject, stateSubject] event in
                let commandPipe: EditorCommandPipe<Layer>
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
            },
            
            bindings.onNewLayerTap.sink { [commandSubject, stateSubject] in
                stateSubject.value.undoButton.isEnabled = false
                stateSubject.value.redoButton.isEnabled = false
                commandSubject.send(.init(commands: [.movePaintingToUndo, .moveUndoToDrawn, .takeLayer]))
            },
            
            bindings.onLayerTaken.sink { [weak self] layer in
                self?.layerStack.push(layer)
                self?.commandSubject.send(EditorCommandPipe(commands: [.setAssistLayer(layer)]))
            }
        ]
    }
}
