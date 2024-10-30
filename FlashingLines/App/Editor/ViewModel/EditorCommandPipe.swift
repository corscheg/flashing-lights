//
//  EditorCommandPipe.swift
//  29.10.2024
//

import Foundation

struct EditorCommandPipe<Layer> {
    let commands: [Command]
}

// MARK: - Command
extension EditorCommandPipe {
    enum Command {
        case begin(location: CGPoint)
        case `continue`(location: CGPoint, width: CGFloat, color: Color)
        case end(location: CGPoint, width: CGFloat, color: Color)
        case movePaintingToUndo
        case moveUndoToDrawn
        case undo
        case redo
        case takeLayer
        case setAssistLayer(Layer?)
    }
}
