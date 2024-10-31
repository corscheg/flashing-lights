//
//  PanelControlAction.swift
//  28.10.2024
//

import UIKit

protocol PanelControlAction<ContentFactory>: CaseIterable, Hashable, Comparable {
    associatedtype ContentFactory
    var contentKeyPath: KeyPath<ContentFactory, UIControl> { get }
}
