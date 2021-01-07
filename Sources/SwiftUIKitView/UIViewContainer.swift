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
public struct UIViewContainer<Child: UIView>: Identifiable {
    
    public var id: UIView { view }

    /// The type of Layout to apply to the SwiftUI `View`.
    public enum Layout {

        /// Uses the size returned by .`systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)`.
        case intrinsic
        
        /// Uses an intrinsic height combined with a fixed width.
        case fixedWidth(width: CGFloat)
        
        /// A fixed width and height is used.
        case fixed(size: CGSize)
    }
    
    private let view: Child
    private let layout: Layout
    
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
    public init(_ view: @autoclosure () -> Child, layout: Layout = .intrinsic) {
        self.view = view()
        self.layout = layout
        
        switch layout {
        case .intrinsic:
            return
        case .fixed(let size):
            self.view.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            self.view.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        case .fixedWidth(let width):
            self.view.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    /// Applies the correct size to the SwiftUI `View` container.
    /// - Returns: A `View` with the correct size applied.
    public func fixedSize() -> some View {
        let size = self.size
        return frame(width: size.width, height: size.height, alignment: .topLeading)
    }
    
    /// Creates a preview of the `UIViewContainer` with the right size applied.
    /// - Returns: A preview of the container.
    public func preview(displayName: String? = nil) -> some View {
        return fixedSize()
            .previewLayout(.sizeThatFits)
            .previewDisplayName(displayName)
    }
}

// MARK: Preview + UIViewRepresentable

@available(iOS 13, *)
extension UIViewContainer: UIViewRepresentable {

    public func makeUIView(context: Context) -> UIView {
        return view
    }
    
    public func updateUIView(_ view: UIView, context: Context) {}
}

@available(iOS 13.0, *)
extension UIViewContainer: KeyPathReferenceWritable {
    public typealias T = Child
    
    public func set<Value>(_ keyPath: ReferenceWritableKeyPath<Child, Value>, to value: Value) -> Self {
        view[keyPath: keyPath] = value
        return self
    }
}
