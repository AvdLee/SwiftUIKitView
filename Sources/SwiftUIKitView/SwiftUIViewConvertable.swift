//
//  SwiftUIViewConvertable.swift
//  
//
//  Created by Antoine van der Lee on 28/12/2020.
//

import Foundation
import UIKit

/// Defines a type that's convertible to a SwiftUI `View`.
@available(iOS 13.0, *)
public protocol SwiftUIViewConvertable {
    associatedtype View: UIView
    func swiftUIView(layout: Layout) -> UIViewContainer<View>
}

/// Add default protocol comformance for `UIView` instances.
extension UIView: SwiftUIViewConvertable {}

@available(iOS 13.0, *)
public extension SwiftUIViewConvertable where Self: UIView {
    func swiftUIView(layout: Layout) -> UIViewContainer<Self> {
        assert(
            ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1",
            "This method is designed to use in previews only and is not performant for production code. Use `UIViewContainer(<YOUR VIEW>, layout: layout)` instead."
        )
        return UIViewContainer(self, layout: layout)
    }
}
