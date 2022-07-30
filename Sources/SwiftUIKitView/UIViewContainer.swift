//
//  UIViewContainer.swift
//
//
//  Created by Antoine van der Lee on 28/12/2020.
//

import Foundation
import UIKit
import SwiftUI

/// A container for UIKit `UIView` elements. Conforms to the `UIViewRepresentable` protocol to allow conversion into SwiftUI `View`s.
@available(iOS 13.0, *)
@dynamicMemberLookup
public struct UIViewContainer<Child: UIView> {

    let viewCreator: () -> Child
    let layout: Layout

    /// Initializes a `UIViewContainer`
    /// - Parameters:
    ///   - view: `UIView` being previewed
    ///   - layout: The layout to apply on the `UIView`. Defaults to `intrinsic`.
    public init(_ viewCreator: @escaping @autoclosure () -> Child, layout: Layout = .intrinsic) {
        self.viewCreator = viewCreator
        self.layout = layout
    }
    
    public subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<Child, Value>) -> (Value) -> ModifiedUIViewContainer<Self, Child, Value> {
        { self.set(keyPath, to: $0) }
    }
}

// MARK: Preview + UIViewRepresentable

@available(iOS 13, *)
extension UIViewContainer: UIViewRepresentable {
    public func makeCoordinator() -> UIViewContainingCoordinator<Child> {
        // Create an instance of Coordinator
        Coordinator(viewCreator, layout: layout)
    }

    public func makeUIView(context: Context) -> IntrinsicContentView<Child> {
        context.coordinator.createView()
    }
    
    public func updateUIView(_ view: IntrinsicContentView<Child>, context: Context) {
        update(view.contentView, coordinator: context.coordinator, updateContentSize: true)

    }
}

extension UIViewContainer: UIViewContaining {
    public func update(_ uiView: Child, coordinator: UIViewContainingCoordinator<Child>, updateContentSize: Bool) {
        guard updateContentSize else { return }
        coordinator.view?.updateContentSize()
    }
}
