//
//  EditorViewModel.swift
//  29.10.2024
//

import Combine
import Foundation

final class EditorViewModel {
    
}

// MARK: - EditorViewModelProtocol
extension EditorViewModel: EditorViewModelProtocol {
    func setupBindings(_ bindings: EditorBindings) -> any Sequence<AnyCancellable> {
        [
            bindings.onTouchEvent.sink { event in
                switch event {
                case .began(let location):
                    print("BEGAN \(location)")
                case .moved(let location):
                    print("MOVED \(location)")
                case .ended(let location):
                    print("ENDED \(location)")
                }
            }
        ]
    }
}
