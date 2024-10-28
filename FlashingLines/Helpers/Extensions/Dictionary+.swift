//
//  Dictionary+.swift
//  28.10.2024
//

import Foundation

extension Dictionary {
    init(keys: some Sequence<Key>, mapToValues: (Key) -> Value) {
        var dict: [Key: Value] = [:]
        keys.forEach { dict[$0] = mapToValues($0) }
        self = dict
    }
    
    init(keys: some Sequence<Key>, compactMapToValues: (Key) -> Value?) {
        var dict: [Key: Value] = [:]
        keys.forEach {
            if let value = compactMapToValues($0) {
                dict[$0] = value
            }
        }
        self = dict
    }
}
