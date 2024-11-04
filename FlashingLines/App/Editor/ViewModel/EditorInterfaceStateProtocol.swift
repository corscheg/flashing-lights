//
//  EditorInterfaceStateProtocol.swift
//  04.11.2024
//

import Foundation

protocol EditorInterfaceStateProtocol: Equatable {
    var undoButton: ButtonState { get }
    var redoButton: ButtonState { get }
    var deleteButton: ButtonState { get }
    var newLayerButton: ButtonState { get }
    var showLayersButton: ButtonState { get }
    var playButton: ButtonState { get }
    var pauseButton: ButtonState { get }
    var pencilButton: ButtonState { get }
    var brushButton: ButtonState { get }
    var eraseButton: ButtonState { get }
    var shapesButton: ButtonState { get }
    var colorsButton: ButtonState { get }
    var duplicateButton: ButtonState { get }
    var deleteAllButton: ButtonState { get }
    var speedButton: ButtonState { get }
    var isColorPickerShown: Bool { get }
    var initialColorSet: ColorSet { get }
    var selectedColor: Color { get }
}
