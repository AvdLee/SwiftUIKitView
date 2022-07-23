//
//  UIViewContaining.swift
//  
//
//  Created by Antoine van der Lee on 23/07/2022.
//

import Foundation
import UIKit
import SwiftUI

public protocol UIViewContaining: UIViewRepresentable {
    associatedtype Child: UIView
    func set<Value>(_ keyPath: ReferenceWritableKeyPath<Child, Value>, to value: Value) -> ModifiedUIViewContainer<Self, Child, Value>
    func update(_ uiView: Child, coordinator: UIViewContainingCoordinator<Child>, updateContentSize: Bool)
}

extension UIViewContaining {
    public func set<Value>(_ keyPath: ReferenceWritableKeyPath<Child, Value>, to value: Value) -> ModifiedUIViewContainer<Self, Child, Value> {
        ModifiedUIViewContainer(child: self, keyPath: keyPath, value: value)
    }
}

public extension View {
    /// Creates a preview of the `UIViewContainer` with the right size applied.
    /// - Returns: A preview of the container.
    func preview(displayName: String? = nil) -> some View {
        return fixedSize()
            .previewLayout(.sizeThatFits)
            .previewDisplayName(displayName)
    }
}
