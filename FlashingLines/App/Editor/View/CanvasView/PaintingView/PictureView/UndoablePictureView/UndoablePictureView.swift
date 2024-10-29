//
//  UndoablePictureView.swift
//  29.10.2024
//

import UIKit

final class UndoablePictureView: PictureView {
    // MARK: Private Properties
    private var undoBufferedImage: UIImage?
    
    // MARK: Internal Properties
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    func undo() {
        undoBufferedImage = image
        imageView.image = nil
    }
    
    func redo() {
        imageView.image = undoBufferedImage
        undoBufferedImage = nil
    }
    
    func clearBuffer() {
        undoBufferedImage = nil
    }
}
