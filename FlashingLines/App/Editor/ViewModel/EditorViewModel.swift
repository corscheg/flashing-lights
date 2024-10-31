//
//  EditorViewModel.swift
//  29.10.2024
//

import Combine
import Foundation

final class EditorViewModel<Layer> {
    
    // MARK: Private Properties
    private let commandSubject: PassthroughSubject<EditorCommandPipe<Layer, ArrayStack<Layer>>, Never> = .init()
    private let stateSubject: CurrentValueSubject<EditorInterfaceState, Never>
    private var layerStack: ArrayStack<Layer> = []
    
    // MARK: Initializers
    init(colorSet: ColorSet) {
        self.stateSubject = .init(.initial(colorSet: colorSet))
    }
}

// MARK: - EditorViewModelProtocol
extension EditorViewModel: EditorViewModelProtocol {
    typealias Playable = ArrayStack<Layer>
    
    var state: EditorInterfaceState { stateSubject.value }
    
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
                    commandPipe = EditorCommandPipe(commands: [.continue(location: location, width: 10, color: stateSubject.value.selectedColor)])
                case .ended(let location):
                    commandPipe = EditorCommandPipe(commands: [.end(location: location, width: 10, color: stateSubject.value.selectedColor), .movePaintingToUndo])
                    stateSubject.value.undoState = .undo
                }
                
                stateSubject.value.isColorPickerShown = false
                stateSubject.value.colorsButton.isSelected = false
                commandSubject.send(commandPipe)
            },
            
            bindings.onUndoTap.sink { [commandSubject, stateSubject] in
                commandSubject.send(.init(commands: [.undo]))
                stateSubject.value.undoState = .redo
                stateSubject.value.isColorPickerShown = false
                stateSubject.value.colorsButton.isSelected = false
            },
            
            bindings.onRedoTap.sink { [commandSubject, stateSubject] in
                commandSubject.send(.init(commands: [.redo]))
                stateSubject.value.undoState = .undo
                stateSubject.value.isColorPickerShown = false
                stateSubject.value.colorsButton.isSelected = false
            },
            
            bindings.onNewLayerTap.sink { [commandSubject, stateSubject] in
                stateSubject.value.undoState = .unavailable
                commandSubject.send(.init(commands: [.movePaintingToUndo, .moveUndoToDrawn, .takeLayer]))
                stateSubject.value.isColorPickerShown = false
                stateSubject.value.colorsButton.isSelected = false
            },
            
            bindings.onLayerTaken.sink { [weak self, stateSubject] layer in
                self?.layerStack.push(layer)
                self?.commandSubject.send(EditorCommandPipe(commands: [.setAssistLayer(layer)]))
                stateSubject.value.isColorPickerShown = false
                stateSubject.value.colorsButton.isSelected = false
            },
            
            bindings.onDeleteTap.sink { [weak self, stateSubject] in
                var commandPipe = EditorCommandPipe<Layer, ArrayStack<Layer>>(commands: [.clearCanvas])
                if let layer = self?.layerStack.pop() {
                    commandPipe.commands.append(.setDrawn(layer))
                }
                
                commandPipe.commands.append(.setAssistLayer(self?.layerStack.peek()))
                
                self?.commandSubject.send(commandPipe)
                stateSubject.value.isColorPickerShown = false
                stateSubject.value.colorsButton.isSelected = false
            },
            
            bindings.onPlayTap.sink { [weak self] in
                guard let `self` else { return }
                stateSubject.value.disableForPlayback()
                commandSubject.send(.init(commands: [.play(layerStack)]))
                stateSubject.value.isColorPickerShown = false
                stateSubject.value.colorsButton.isSelected = false
            },
            
            bindings.onPauseTap.sink { [commandSubject, stateSubject] in
                stateSubject.value.enableForPlaybackEnd()
                stateSubject.value.syncUndoRedo()
                commandSubject.send(.init(commands: [.stop]))
                stateSubject.value.isColorPickerShown = false
                stateSubject.value.colorsButton.isSelected = false
            },
            
            bindings.onColorsTap.sink { [stateSubject] in
                stateSubject.value.isColorPickerShown = true
                stateSubject.value.colorsButton.isSelected = true
            },
            
            bindings.onColorSelect.sink { [stateSubject] color in
                stateSubject.value.isColorPickerShown = false
                stateSubject.value.colorsButton.isSelected = false
                stateSubject.value.selectedColor = color
            }
        ]
    }
}
