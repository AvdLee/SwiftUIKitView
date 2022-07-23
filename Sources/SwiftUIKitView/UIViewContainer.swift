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
public struct UIViewContainer<Child: UIView> { //}: Identifiable {
    
//    public var id: UIView { view }

    /// The type of Layout to apply to the SwiftUI `View`.
    public enum Layout {

        /// Uses the size returned by .`systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)`.
        case intrinsic
        
        /// Uses an intrinsic height combined with a fixed width.
        case fixedWidth(width: CGFloat)
        
        /// A fixed width and height is used.
        case fixed(size: CGSize)
    }
    
    var view: Child! {
        get { coordinator.view }
    }
    private let viewCreator: () -> Child
    private let layout: Layout
    private let coordinator: Coordinator<Child>

    /// - Returns: The `CGSize` to apply to the view.
    private var size: CGSize {
        switch layout {
        case .fixedWidth(let width):
            // Set the frame of the cell, so that the layout can be updated.
            var newFrame = view.frame
            newFrame.size = CGSize(width: width, height: UIView.layoutFittingExpandedSize.height)
            view.frame = newFrame
            
            // Make sure the contents of the cell have the correct layout.
            view.setNeedsLayout()
            view.layoutIfNeeded()
            
            // Get the size of the cell
            let computedSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            
            // Apple: "Only consider the height for cells, because the contentView isn't anchored correctly sometimes." We use ceil to make sure we get rounded numbers and no half pixels.
            return CGSize(width: width, height: ceil(computedSize.height))
        case .fixed(let size):
            return size
        case .intrinsic:
            return view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        }
    }
    
    /// Initializes a `UIViewContainer`
    /// - Parameters:
    ///   - view: `UIView` being previewed
    ///   - layout: The layout to apply on the `UIView`. Defaults to `intrinsic`.
    public init(_ view: @escaping @autoclosure () -> Child, layout: Layout = .intrinsic) {
        self.viewCreator = view
        self.layout = layout
        self.coordinator = Coordinator(self.viewCreator)
    }
    
    /// Applies the correct size to the SwiftUI `View` container.
    /// - Returns: A `View` with the correct size applied.
//    public func fixedSize() -> some View {
//        let size = self.size
//        return frame(width: size.width, height: size.height, alignment: .topLeading)
//    }
    
    /// Creates a preview of the `UIViewContainer` with the right size applied.
    /// - Returns: A preview of the container.
    public func preview(displayName: String? = nil) -> some View {
        return fixedSize()
            .previewLayout(.sizeThatFits)
            .previewDisplayName(displayName)
    }

    public class Coordinator<Child> {
        var view: Child!
        var viewCreator: () -> Child
        var modifiers: [(Child) -> Void] = []

        init(_ viewCreator: @escaping () -> Child) {
            self.viewCreator = viewCreator
        }
    }
}

// MARK: Preview + UIViewRepresentable

@available(iOS 13, *)
extension UIViewContainer: UIViewRepresentable {
    public func makeCoordinator() -> Coordinator<Child> {
        // Create an instance of Coordinator
        coordinator
    }

    public func makeUIView(context: Context) -> Child {
        self.coordinator.view = viewCreator()
        coordinator.modifiers.forEach { modifier in
            modifier(self.coordinator.view)
        }
        switch layout {
        case .intrinsic:
            return view
        case .fixed(let size):
            self.view.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            self.view.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        case .fixedWidth(let width):
            self.view.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        return view
    }
    
    public func updateUIView(_ view: Child, context: Context) {
        coordinator.modifiers.forEach { modifier in
            modifier(view)
        }
    }
}

@available(iOS 13.0, *)
extension UIViewContainer: KeyPathReferenceWritable {
    public typealias T = Child
    
    public func set<Value>(_ keyPath: ReferenceWritableKeyPath<Child, Value>, to value: Value) -> Self {
        coordinator.modifiers.append({ view in
            view[keyPath: keyPath] = value
        })
        print("Modifiers is now \(coordinator.modifiers)")
        return self
    }
}
