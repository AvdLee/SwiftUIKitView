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
//                UIViewMaker<UILabel> {
//                    $0.text = "Hello no \(self.integer) from UIKit"
//                }
//                .fixedSize()
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

struct UIViewMaker<ViewType: UIView>: UIViewRepresentable {

    typealias UIViewType = ViewType

    var make: () -> ViewType = ViewType.init
    var update: (ViewType) -> ()

    func makeUIView(context: Context) -> ViewType {
        return make()
    }

    func updateUIView(_ uiView: ViewType, context: Context) {
        update(uiView)
    }
}

struct ContentView: View {
    @State var counter = 0

    var body: some View {
        VStack {

            Text("Hello no \(counter) from SwiftUI")
                .padding()


            UIViewMaker<UILabel> {
                $0.text = "Hello no \(self.counter) from UIKit"
            }
            .fixedSize()

        }
        .onAppear {
            if counter == 0 {
                schedule()
            }
        }
    }

    func schedule() {
        counter += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.schedule()
        }
    }

}

