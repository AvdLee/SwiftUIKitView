//
//  SwiftUIwithUIKitView.swift
//  SwiftUIKitExample
//
//  Created by Antoine van der Lee on 28/12/2020.
//

import SwiftUI
import SwiftUIKitView

struct SwiftUIwithUIKitView: View {
    @State var integer: Int = 0

    var body: some View {
        NavigationView {
            VStack {
                // Use UIKit inside SwiftUI like this:
                UIViewContainer(UIKitView(), layout: .intrinsic)
                    .set(\.title, to: "Hello, UIKit \(integer)!")
                    .set(\.backgroundColor, to: UIColor(named: "swiftlee_orange"))
                    .fixedSize()
                    .navigationTitle("Use UIKit in SwiftUI")

                Button("RANDOMIZED: \(integer)") {
                    integer = Int.random(in: 0..<300)
                }
            }
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
            .set(\.text, to: "Hello, UIKit!") // <- Use key paths for updates.
            .fixedSize() // <- Make sure the size is set
            .previewLayout(.sizeThatFits)
            .previewDisplayName("UILabel Preview Example")
    }
}
