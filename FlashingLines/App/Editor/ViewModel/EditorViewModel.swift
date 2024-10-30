//
//  EditorViewModel.swift
//  29.10.2024
//

import Combine
import Foundation

final class EditorViewModel<Layer> {
    
    // MARK: Private Properties
    private let commandSubject: PassthroughSubject<EditorCommandPipe<Layer, ArrayStack<Layer>>, Never> = .init()
    private let stateSubject: CurrentValueSubject<EditorInterfaceState, Never> = .init(.initial)
    private var layerStack: ArrayStack<Layer> = []
}

// MARK: - EditorViewModelProtocol
extension EditorViewModel: EditorViewModelProtocol {
    typealias Playable = ArrayStack<Layer>
    var commandPublisher: any Publisher<EditorCommandPipe<Layer, ArrayStack<Layer>>, Never> {
        commandSubject.eraseToAnyPublisher()
    }
    
    var statePublisher: any Publisher<EditorInterfaceState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    func setupBindings(_ bindings: EditorBindings<Layer>) -> any Sequence<AnyCancellable> {
        [
            bindings.onTouchEvent.sink { [commandSubject, stateSubject] event in
                let commandPipe: EditorCommandPipe<Layer, ArrayStack<Layer>>
                switch event {
                case .began(let location):
                    commandPipe = EditorCommandPipe(commands: [.moveUndoToDrawn, .begin(location: location)])
                    stateSubject.value.undoState = .unavailable
                case .moved(let location):
                    commandPipe = EditorCommandPipe(commands: [.continue(location: location, width: 10, color: Color(red: 0, green: 0, blue: 0, alpha: 0xFF))])
                case .ended(let location):
                    commandPipe = EditorCommandPipe(commands: [.end(location: location, width: 10, color: Color(red: 0, green: 0, blue: 0, alpha: 0xFF)), .movePaintingToUndo])
                    stateSubject.value.undoState = .undo
                }
                
                commandSubject.send(commandPipe)
            },
            
            bindings.onUndoTap.sink { [commandSubject, stateSubject] in
                commandSubject.send(.init(commands: [.undo]))
                stateSubject.value.undoState = .redo
            },
            
            bindings.onRedoTap.sink { [commandSubject, stateSubject] in
                commandSubject.send(.init(commands: [.redo]))
                stateSubject.value.undoState = .undo
            },
            
            bindings.onNewLayerTap.sink { [commandSubject, stateSubject] in
                stateSubject.value.undoState = .unavailable
                commandSubject.send(.init(commands: [.movePaintingToUndo, .moveUndoToDrawn, .takeLayer]))
            },
            
            bindings.onLayerTaken.sink { [weak self] layer in
                self?.layerStack.push(layer)
                self?.commandSubject.send(EditorCommandPipe(commands: [.setAssistLayer(layer)]))
            },
            
            bindings.onDeleteTap.sink { [weak self] in
                var commandPipe = EditorCommandPipe<Layer, ArrayStack<Layer>>(commands: [.clearCanvas])
                if let layer = self?.layerStack.pop() {
                    commandPipe.commands.append(.setDrawn(layer))
                }
                
                commandPipe.commands.append(.setAssistLayer(self?.layerStack.peek()))
                
                self?.commandSubject.send(commandPipe)
            },
            
            bindings.onPlayTap.sink { [weak self] in
                guard let `self` else { return }
                stateSubject.value.disableForPlayback()
                commandSubject.send(.init(commands: [.play(layerStack)]))
            },
            
            bindings.onPauseTap.sink { [commandSubject, stateSubject] in
                stateSubject.value.enableForPlaybackEnd()
                stateSubject.value.syncUndoRedo()
                commandSubject.send(.init(commands: [.stop]))
            }
        ]
    }
}
