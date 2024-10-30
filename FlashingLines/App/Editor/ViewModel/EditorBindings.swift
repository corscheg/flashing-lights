//
//  EditorBindings.swift
//  29.10.2024
//

import Combine
import Foundation

struct EditorBindings<Layer> {
    let onUndoTap: PassthroughSubject<Void, Never> = .init()
    let onRedoTap: PassthroughSubject<Void, Never> = .init()
    let onDeleteTap: PassthroughSubject<Void, Never> = .init()
    let onNewLayerTap: PassthroughSubject<Void, Never> = .init()
    let onShowLayersTap: PassthroughSubject<Void, Never> = .init()
    let onPlayTap: PassthroughSubject<Void, Never> = .init()
    let onPauseTap: PassthroughSubject<Void, Never> = .init()
    let onPencilTap: PassthroughSubject<Void, Never> = .init()
    let onBrushTap: PassthroughSubject<Void, Never> = .init()
    let onEraseTap: PassthroughSubject<Void, Never> = .init()
    let onShapesTap: PassthroughSubject<Void, Never> = .init()
    let onTouchEvent: PassthroughSubject<TouchEvent, Never> = .init()
    let onLayerTaken: PassthroughSubject<Layer, Never> = .init()
}
