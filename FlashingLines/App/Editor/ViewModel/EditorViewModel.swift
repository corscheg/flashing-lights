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
    private let defaultWidth: CGFloat = 10
    
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
            bindings.onTouchEvent.sink { [commandSubject, stateSubject, defaultWidth] event in
                let commandPipe: EditorCommandPipe<Layer, ArrayStack<Layer>>
                switch event {
                case .began(let location):
                    if stateSubject.value.isEraserSelected {
                        commandPipe = EditorCommandPipe(commands: [.moveUndoToDrawn, .commitErase, .beginErase(location: location)])
                    } else {
                        commandPipe = EditorCommandPipe(commands: [.moveUndoToDrawn, .commitErase, .begin(location: location)])
                    }
                    
                    stateSubject.value.undoState = .unavailable
                case .moved(let location):
                    if stateSubject.value.isEraserSelected {
                        commandPipe = EditorCommandPipe(commands: [.continueErase(location: location, width: defaultWidth)])
                    } else {
                        commandPipe = EditorCommandPipe(commands: [.continue(location: location, width: defaultWidth, color: stateSubject.value.selectedColor)])
                    }
                    
                case .ended(let location):
                    if stateSubject.value.isEraserSelected {
                        commandPipe = EditorCommandPipe(commands: [.endErase(location: location, width: defaultWidth)])
                        stateSubject.value.lastAction = .erase
                    } else {
                        commandPipe = EditorCommandPipe(commands: [.end(location: location, width: defaultWidth, color: stateSubject.value.selectedColor), .movePaintingToUndo])
                        stateSubject.value.lastAction = .paint
                    }
                    
                    stateSubject.value.undoState = .undo
                }
                
                stateSubject.value.isColorPickerShown = false
                stateSubject.value.colorsButton.isSelected = false
                commandSubject.send(commandPipe)
            },
            
            bindings.onUndoTap.sink { [commandSubject, stateSubject] in
                switch stateSubject.value.lastAction {
                case .paint:
                    commandSubject.send(.init(commands: [.undo]))
                case .erase:
                    commandSubject.send(.init(commands: [.undoErase]))
                }
                
                stateSubject.value.undoState = .redo
                stateSubject.value.isColorPickerShown = false
                stateSubject.value.colorsButton.isSelected = false
            },
            
            bindings.onRedoTap.sink { [commandSubject, stateSubject] in
                switch stateSubject.value.lastAction {
                case .paint:
                    commandSubject.send(.init(commands: [.redo]))
                case .erase:
                    commandSubject.send(.init(commands: [.redoErase]))
                }
                stateSubject.value.undoState = .undo
                stateSubject.value.isColorPickerShown = false
                stateSubject.value.colorsButton.isSelected = false
            },
            
            bindings.onNewLayerTap.sink { [weak self] in
                self?.takeLayer(duplicate: false)
            },
            
            bindings.onLayerTaken.sink { [weak self, stateSubject] layer in
                self?.layerStack.push(layer.layer)
                var pipe = EditorCommandPipe<Layer, ArrayStack<Layer>>(commands: [.setAssistLayer(layer.layer)])
                if layer.duplicate {
                    pipe.commands.append(.setDrawn(layer.layer))
                }
                self?.commandSubject.send(pipe)
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
            },
            
            bindings.onEraseTap.sink { [stateSubject] in
                stateSubject.value.isEraserSelected = true
                stateSubject.value.eraseButton.isSelected = true
                stateSubject.value.pencilButton.isSelected = false
            },
            
            bindings.onPencilTap.sink { [stateSubject] in
                stateSubject.value.isEraserSelected = false
                stateSubject.value.eraseButton.isSelected = false
                stateSubject.value.pencilButton.isSelected = true
            },
            
            bindings.onDuplicateTap.sink { [weak self] in
                self?.takeLayer(duplicate: true)
            },
            
            bindings.onDeleteAllTap.sink { [weak self] in
                guard let `self` else { return }
                
                layerStack.clear()
                stateSubject.value.undoState = .unavailable
                commandSubject.send(.init(commands: [.commitErase, .clearCanvas, .setAssistLayer(nil)]))
            }
        ]
    }
}

// MARK: - Private Methods
extension EditorViewModel {
    func takeLayer(duplicate: Bool) {
        stateSubject.value.undoState = .unavailable
        commandSubject.send(.init(commands: [.movePaintingToUndo, .moveUndoToDrawn, .commitErase, .takeLayer(duplicate: duplicate)]))
        stateSubject.value.isColorPickerShown = false
        stateSubject.value.colorsButton.isSelected = false
    }
}
