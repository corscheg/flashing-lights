//
//  CanvasResponderView.swift
//  29.10.2024
//

import Combine
import UIKit

final class CanvasResponderView: UIView {
    
    // MARK: Internal Properties
    var eventPublisher: some Publisher<TouchEvent, Never> { eventSubject.eraseToAnyPublisher() }
    
    // MARK: Private Properties
    private let eventSubject: PassthroughSubject<TouchEvent, Never> = .init()
    private let screen: UIScreen
    
    // MARK: Initializers
    init(frame: CGRect, screen: UIScreen) {
        self.screen = screen
        super.init(frame: frame)
    }
    
    convenience init(screen: UIScreen) {
        self.init(frame: .zero, screen: screen)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        let externalEvent: TouchEvent = switch event {
        case .began:
                .began(location: location)
        case .moved:
                .moved(location: location)
        case .ended:
                .ended(location: location)
        }
        
        eventSubject.send(externalEvent)
    }
}
