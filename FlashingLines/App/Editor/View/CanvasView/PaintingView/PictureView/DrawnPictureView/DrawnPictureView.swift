//
//  DrawnPictureView.swift
//  29.10.2024
//

import UIKit

final class DrawnPictureView: PictureView {
    // MARK: Internal Methods
    func mergeImage(_ image: UIImage) {
        imageView.image = UIGraphicsImageRenderer(size: bounds.size).image { context in
            imageView.image?.draw(in: bounds)
            image.draw(in: bounds)
        }
    }
}
