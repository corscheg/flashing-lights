//
//  PanelControlAction.swift
//  28.10.2024
//

import UIKit

protocol PanelControlAction<IconSet>: CaseIterable, Hashable, Comparable {
    associatedtype IconSet
    var image: KeyPath<IconSet, UIImage> { get }
}
