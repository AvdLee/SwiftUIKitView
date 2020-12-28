//
//  SwiftUIwithUIKitView.swift
//  SwiftUIKitExample
//
//  Created by Antoine van der Lee on 28/12/2020.
//

import SwiftUI
import SwiftUIKitView

struct SwiftUIwithUIKitView: View {
    var body: some View {
        NavigationView {
            UIKitView() // <- This is a `UIKit` view.
                .swiftUIView(layout: .intrinsic) // <- This is a SwiftUI `View`.
                .set(\.title, to: "Hello, UIKit!")
                .set(\.backgroundColor, to: UIColor(named: "swiftlee_orange"))
                .fixedSize()
                .navigationTitle("Use UIKit in SwiftUI")
        }
    }
}

struct SwiftUIwithUIKitView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIwithUIKitView()
    }
}

// MARK: - UILabel Preview Example
struct UILabelExample_Preview: PreviewProvider {
    static var previews: some View {
        UILabel() // <- This is a `UIKit` view.
            .swiftUIView(layout: .intrinsic) // <- This is a SwiftUI `View`.
            .set(\.text, to: "Hello, UIKit!")
            .preview(displayName: "UILabel Preview Example")
    }
}
