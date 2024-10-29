//
//  CanvasResponderView.swift
//  29.10.2024
//

import Combine
import UIKit

final class CanvasResponderView: UIView {
    
    // MARK: Internal Properties
    var eventPublisher: some Publisher<Event, Never> { eventSubject.eraseToAnyPublisher() }
    
    // MARK: Private Properties
    private let eventSubject: PassthroughSubject<Event, Never> = .init()
    
    // MARK: UIResponder
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sendEvent(.began, touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        sendEvent(.moved, touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        sendEvent(.ended, touches: touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        sendEvent(.ended, touches: touches)
    }
}

// MARK: - Event
extension CanvasResponderView {
    enum Event {
        case began(location: Point)
        case moved(location: Point)
        case ended(location: Point)
    }
}

// MARK: - PlainEvent
extension CanvasResponderView {
    enum PlainEvent {
        case began
        case moved
        case ended
    }
}

// MARK: - Private Methods
extension CanvasResponderView {
    private func sendEvent(_ event: PlainEvent, touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let point = Point(cgPoint: location, scale: 2)
        
        let externalEvent: Event = switch event {
        case .began:
                .began(location: point)
        case .moved:
                .moved(location: point)
        case .ended:
                .ended(location: point)
        }
        
        eventSubject.send(Event)
    }
}
