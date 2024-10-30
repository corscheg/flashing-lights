//
//  EditorInterfaceState.swift
//  30.10.2024
//

import Foundation

struct EditorInterfaceState {
    
    // MARK: Internal Properties
    var undoState: UndoState {
        didSet {
            syncUndoRedo()
        }
    }
    var undoButton: ButtonState
    var redoButton: ButtonState
    var deleteButton: ButtonState
    var newLayerButton: ButtonState
    var showLayersButton: ButtonState
    var playButton: ButtonState
    var pauseButton: ButtonState
    var pencilButton: ButtonState
    var brushButton: ButtonState
    var eraseButton: ButtonState
    var shapesButton: ButtonState
    
    static var initial: EditorInterfaceState {
        .init(
            undoState: .unavailable,
            undoButton: .init(isSelected: false, isEnabled: false),
            redoButton: .init(isSelected: false, isEnabled: false),
            deleteButton: .init(isSelected: false, isEnabled: true),
            newLayerButton: .init(isSelected: false, isEnabled: true),
            showLayersButton: .init(isSelected: false, isEnabled: true),
            playButton: .init(isSelected: false, isEnabled: true),
            pauseButton: .init(isSelected: false, isEnabled: false),
            pencilButton: .init(isSelected: true, isEnabled: true),
            brushButton: .init(isSelected: false, isEnabled: true),
            eraseButton: .init(isSelected: false, isEnabled: true),
            shapesButton: .init(isSelected: false, isEnabled: true)
        )
    }
    
    mutating func syncUndoRedo() {
        switch undoState {
        case .unavailable:
            undoButton.isEnabled = false
            redoButton.isEnabled = false
        case .undo:
            undoButton.isEnabled = true
            redoButton.isEnabled = false
        case .redo:
            undoButton.isEnabled = false
            redoButton.isEnabled = true
        }
    }
    
    mutating func disableForPlayback() {
        undoButton.isEnabled = false
        redoButton.isEnabled = false
        deleteButton.isEnabled = false
        newLayerButton.isEnabled = false
        showLayersButton.isEnabled = false
        playButton.isEnabled = false
        pauseButton.isEnabled = true
        pencilButton.isEnabled = false
        brushButton.isEnabled = false
        eraseButton.isEnabled = false
        shapesButton.isEnabled = false
    }
    
    mutating func enableForPlaybackEnd() {
        undoButton.isEnabled = true
        redoButton.isEnabled = true
        deleteButton.isEnabled = true
        newLayerButton.isEnabled = true
        showLayersButton.isEnabled = true
        playButton.isEnabled = true
        pauseButton.isEnabled = false
        pencilButton.isEnabled = true
        brushButton.isEnabled = true
    }
}

// MARK: - UndoState
extension EditorInterfaceState {
    enum UndoState {
        case unavailable
        case undo
        case redo
    }
}

// MARK: -  ButtonState
extension EditorInterfaceState {
    struct ButtonState {
        var isSelected: Bool
        var isEnabled: Bool
    }
}
