//
//  UIViewContainingCoordinator.swift
//  
//
//  Created by Antoine van der Lee on 23/07/2022.
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

    func createView() -> IntrinsicContentView<Child> {
        if let view = view {
            return view
        } else {
            let contentView = IntrinsicContentView(contentView: viewCreator(), layout: layout)
            view = contentView
            return contentView
        }
    }
}
