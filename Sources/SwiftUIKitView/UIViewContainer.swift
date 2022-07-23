//
//  UIViewContainer.swift
//
//
//  Created by Antoine van der Lee on 28/12/2020.
//

import Foundation
import UIKit
import SwiftUI

/// The type of Layout to apply to the SwiftUI `View`.
public enum Layout {

    /// Uses the size returned by .`systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)`.
    case intrinsic

    /// Uses an intrinsic height combined with a fixed width.
    case fixedWidth(width: CGFloat)

    /// A fixed width and height is used.
    case fixed(size: CGSize)
}

public class UIViewContainingCoordinator<Child: UIView> {
    private(set) var view: IntrinsicContentView<Child>?
    private var viewCreator: () -> Child

    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    private let layout: Layout

    init(_ viewCreator: @escaping () -> Child, layout: Layout) {
        self.viewCreator = viewCreator
        self.layout = layout
    }

    func createView() {
        guard view == nil else { return }
        let contentView = viewCreator()
        view = IntrinsicContentView(contentView: contentView, layout: layout)
    }

    func updateSize(for view: Child) {
//        switch layout {
//        case .intrinsic:
//            break
//        case .fixed(let size):
//            update(view: view, width: size.width, height: size.height)
//        case .fixedWidth(let width):
//            update(view: view, width: width, height: nil)
//        }
    }

    private func update(view: Child, width: CGFloat?, height: CGFloat?) {
        if let width = width {
            if let widthConstraint = widthConstraint {
                widthConstraint.constant = width
            } else {
                widthConstraint = view.widthAnchor.constraint(equalToConstant: width)
                widthConstraint?.isActive = true
            }
        }
        if let height = height {
            if let heightConstraint = heightConstraint {
                heightConstraint.constant = height
            } else {
                heightConstraint = view.heightAnchor.constraint(equalToConstant: height)
                heightConstraint?.isActive = true
            }
        }
    }

    /// - Returns: The `CGSize` to apply to the view.
    func size(for view: Child) -> CGSize {
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
}

/// A container for UIKit `UIView` elements. Conforms to the `UIViewRepresentable` protocol to allow conversion into SwiftUI `View`s.
@available(iOS 13.0, *)
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
}

// MARK: Preview + UIViewRepresentable

@available(iOS 13, *)
extension UIViewContainer: UIViewRepresentable {
    public func makeCoordinator() -> UIViewContainingCoordinator<Child> {
        // Create an instance of Coordinator
        Coordinator(viewCreator, layout: layout)
    }

    public func makeUIView(context: Context) -> IntrinsicContentView<Child> {
        print("MAKE VIEW")
        context.coordinator.createView()
        return context.coordinator.view!
    }
    
    public func updateUIView(_ view: IntrinsicContentView<Child>, context: Context) {
        print("UPDATE VIEW")
        update(view.contentView, coordinator: context.coordinator, updateContentSize: true)

    }

    public func update(_ uiView: Child, coordinator: UIViewContainingCoordinator<Child>, updateContentSize: Bool) {
        print("UPDATE UIViewContainer")
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        coordinator.updateSize(for: uiView)
        print(uiView.intrinsicContentSize)
    }
}

public protocol UIViewContaining: UIViewRepresentable {
    associatedtype Child: UIView
    func set<Value>(_ keyPath: ReferenceWritableKeyPath<Child, Value>, to value: Value) -> ModifiedUIViewContainer<Self, Child, Value>
    func update(_ uiView: Child, coordinator: UIViewContainingCoordinator<Child>, updateContentSize: Bool)
}

extension UIViewContaining {
    public func set<Value>(_ keyPath: ReferenceWritableKeyPath<Child, Value>, to value: Value) -> ModifiedUIViewContainer<Self, Child, Value> {
        ModifiedUIViewContainer(child: self, keyPath: keyPath, value: value)
    }

//    public func fixedSize() -> some View
//    {
//        print("FIXED SIZE")
//        return self.background(Color.blue)
//    }

    /// Applies the correct size to the SwiftUI `View` container.
    /// - Returns: A `View` with the correct size applied.
//    public func fixedSizing() -> some View {
//        if let view = coordinator.view {
//            update(coordinator.view!)
//            let size = coordinator.size(for: view)
//            return self.frame(width: size.width, height: size.height, alignment: .topLeading)
//        } else {
//            return self
//        }
//    }

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

extension UIViewContainer: UIViewContaining { }
public struct ModifiedUIViewContainer<ChildContainer: UIViewContaining, Child, Value>: UIViewContaining where ChildContainer.Child == Child {
    var child: ChildContainer

    @State var keyPath: ReferenceWritableKeyPath<Child, Value>
    @State var value: Value

    public func makeCoordinator() -> UIViewContainingCoordinator<Child> {
        child.makeCoordinator() as! UIViewContainingCoordinator<Child>
    }

    public func makeUIView(context: Context) -> IntrinsicContentView<Child> {
        context.coordinator.createView()
        return context.coordinator.view!
    }

    public func updateUIView(_ uiView: IntrinsicContentView<Child>, context: Context) {
        update(uiView.contentView, coordinator: context.coordinator, updateContentSize: true)
    }

    public func update(_ uiView: Child, coordinator: UIViewContainingCoordinator<Child>, updateContentSize: Bool) {
        print("UPDATE Modified \(keyPath)")
        uiView[keyPath: keyPath] = value
        child.update(uiView, coordinator: coordinator, updateContentSize: false)
        coordinator.updateSize(for: uiView)

        if updateContentSize {
            coordinator.view?.updateContentSize()
        }
    }
}
