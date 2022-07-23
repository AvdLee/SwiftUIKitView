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
        return UIViewContainer(self, layout: layout)
    }
}
