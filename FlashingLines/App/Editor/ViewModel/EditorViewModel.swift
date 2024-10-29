//
//  EditorViewModel.swift
//  29.10.2024
//

import Combine
import Foundation

final class EditorViewModel {
    // MARK: Private Properties
    private var paintings: [Painting] = []
    private var brushSize: UInt16 = 30
    private var color: Color = .init(values: .init(0, 0, 0, 1))
    private let stateSubject: PassthroughSubject<EditorState, Never> = .init()
}

// MARK: - EditorViewModelProtocol
extension EditorViewModel: EditorViewModelProtocol {
    var statePublisher: any Publisher<EditorState, Never> { stateSubject.eraseToAnyPublisher() }
    
    func setupBindings(_ bindings: EditorBindings) -> any Sequence<AnyCancellable> {
        [
            bindings.onTouchEvent.sink { [weak self] event in
                guard let `self` else { return }
                switch event {
                case .began(let location):
                    startDrawing(at: location)
                    stateSubject.send(EditorState(paintings: paintings))
                case .moved(let location):
                    print("MOVED \(location)")
                case .ended(let location):
                    print("ENDED \(location)")
                }
            }
        ]
    }
}

// MARK: - Private Methods
extension EditorViewModel {
    private func startDrawing(at location: Point) {
        let xRange = (location.x - brushSize / 2)...(location.x + brushSize / 2)
        let yRange = (location.y - brushSize / 2)...(location.y + brushSize / 2)
        
        for x in xRange {
            for y in yRange {
                let candidatePoint = Point(x: x, y: y)
                let distance = distance(between: location, and: candidatePoint)
                if distance <= Int(brushSize / 2) {
                    paintings.append(Painting(location: .init(x, y), color: color))
                }
            }
        }
    }
    
    private func distance(between lhs: Point, and rhs: Point) -> UInt16 {
        let xDistance = Int(lhs.x) - Int(rhs.x)
        let yDistance = Int(lhs.y) - Int(rhs.y)
        let xSquared = Double(xDistance * xDistance)
        let ySquared = Double(yDistance * yDistance)
        let distanceSquared = xSquared + ySquared
        let distance = distanceSquared.squareRoot()
        return UInt16(distance)
    }
}
