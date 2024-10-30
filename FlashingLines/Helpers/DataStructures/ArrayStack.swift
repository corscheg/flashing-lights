//
//  ArrayStack.swift
//  30.10.2024
//

import Foundation

struct ArrayStack<Element> {
    
    // MARK: Private Properties
    private var storage: [Element] = []
    
    // MARK: Internal Methods
    mutating func push(_ element: Element) {
        storage.append(element)
    }
    
    mutating func pop() -> Element? {
        storage.popLast()
    }
    
    var isEmpty: Bool {
        storage.isEmpty
    }
    
    func peek() -> Element? {
        storage.last
    }
}

// MARK: - BidirectionalCollection
extension ArrayStack: BidirectionalCollection {
    subscript(position: Array<Element>.Index) -> Element {
        storage[position]
    }
    
    func index(before i: Array<Element>.Index) -> Array<Element>.Index {
        storage.index(before: i)
    }
    
    func index(after i: Array<Element>.Index) -> Array<Element>.Index {
        storage.index(after: i)
    }
    
    var startIndex: Array<Element>.Index {
        storage.startIndex
    }
    
    var endIndex: Array<Element>.Index {
        storage.endIndex
    }
    
    typealias Index = Array<Element>.Index
}

// MARK: - ExpressibleByArrayLiteral
extension ArrayStack: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self.storage = elements
    }
}
