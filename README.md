# SwiftUIKitView
![Swift Version](https://img.shields.io/badge/Swift-5.5-F16D39.svg?style=flat) ![Dependency frameworks](https://img.shields.io/badge/Supports-_Swift_Package_Manager-F16D39.svg?style=flat) [![Twitter](https://img.shields.io/badge/twitter-@Twannl-blue.svg?style=flat)](https://twitter.com/twannl)

Easily use UIKit views in SwiftUI.

- Convert `UIView` to SwiftUI `View`
- Create Xcode Previews from `UIView` elements
- SwiftUI functional updating `UIView` properties using a protocol with [Associated Types](https://www.avanderlee.com/swift/associated-types-protocols/).

You can read more about [Getting started with UIKit in SwiftUI and visa versa](https://www.avanderlee.com/swiftui/integrating-swiftui-with-uikit/).

## Examples

### Using SwiftUIKitView in Production Code
Using a `UIKit` view directly in SwiftUI for production code requires you to use:

```swift
UIViewContainer(<YOUR UIKit View>, layout: <YOUR LAYOUT PREFERENCE>)
```

This is to prevent a UIKit view from being redrawn on every SwiftUI view redraw.

```swift
import SwiftUI
import SwiftUIKitView

struct SwiftUIwithUIKitView: View {
    var body: some View {
        NavigationView {
            UIViewContainer(UILabel(), layout: .intrinsic) // <- This can be any `UIKit` view.
                .set(\.text, to: "Hello, UIKit!") // <- Use key paths for updates.
                .set(\.backgroundColor, to: UIColor(named: "swiftlee_orange"))
                .fixedSize()
                .navigationTitle("Use UIKit in SwiftUI")
        }
    }
}
```

### Using `SwiftUIKitView` in Previews
Performance in Previews is less important, it's being redrawn either way.

Therefore, you can use the more convenient  `swiftUIView()` modifier:

```swift
UILabel() // <- This is a `UIKit` view.
    .swiftUIView(layout: .intrinsic) // <- This is returning a SwiftUI `View`.
```

Creating a preview provider for a `UIView` looks as follows:

```swift
import SwiftUI
import SwiftUIKitView

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
```

Which results in the following preview:

<img src="Assets/uikit_uilabel_preview.png" width="750"/>

### KeyPath updating

This framework also comes with a `KeyPathReferenceWritable` protocol that allows to update objects using functions and writable KeyPath references:

```swift
/// Defines a type that is configurable using reference writeable keypaths.
public protocol KeyPathReferenceWritable {
    associatedtype T
    associatedtype U
    
    func set<Value>(_ keyPath: ReferenceWritableKeyPath<T, Value>, to value: Value) -> U
}

public extension KeyPathReferenceWritable {
    func set<Value>(_ keyPath: ReferenceWritableKeyPath<Self, Value>, to value: Value) -> Self {
        self[keyPath: keyPath] = value
        return self
    }
}

/// Add inheritance for NSObject types to make the methods accessible for many default types.
extension NSObject: KeyPathReferenceWritable { }
```

This can be used as follows:

```swift
UILabel()
    .set(\.text, to: "Example")
```

And allows to easily build up SwiftUI style view configurations to keep the same readability when working in SwiftUI.

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but this SDK does support its use on supported platforms. 

Once you have your Swift package set up, adding the SDK as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/AvdLee/SwiftUIKitView.git", .upToNextMajor(from: "2.0.0"))
]
```

## Communication

- If you **found a bug**, open an [issue](https://github.com/AvdLee/SwiftUIKitView/issues).
- If you **have a feature request**, open an [issue](https://github.com/AvdLee/SwiftUIKitView/issues).
- If you **want to contribute**, submit a [pull request](https://github.com/AvdLee/SwiftUIKitView/pulls).


## License

**SwiftUIKitView** is available under the MIT license, and uses source code from open source projects. See the [LICENSE](https://github.com/AvdLee/SwiftUIKitView/blob/main/LICENSE) file for more info.

## Author

This project is originally created by [Antoine van der Lee](https://www.twitter.com/twannl). I'm open for contributions of any kind to make this project even better.
