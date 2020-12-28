# SwiftUIKitView
Easily use UIKit views in your SwiftUI applications.

![Swift Version](https://img.shields.io/badge/Swift-5.3-F16D39.svg?style=flat) ![Dependency frameworks](https://img.shields.io/badge/Supports-_Swift_Package_Manager-F16D39.svg?style=flat) [![Twitter](https://img.shields.io/badge/twitter-@Twannl-blue.svg?style=flat)](https://twitter.com/twannl)

## Examples

Using a `UIKit` view directly in SwiftUI:

```swift
struct SwiftUIwithUIKitView: View {
    var body: some View {
        NavigationView {
            UIKitView() // <- This is a `UIKit` view.
                .swiftUIView(layout: .intrinsic) // Use .intrinsic, .fixedWidth(*), or .fixed(size).
                .set(\.title, to: "Hello, UIKit!") // Use key paths for SwiftUI style updates.
                .set(\.backgroundColor, to: UIColor(named: "swiftlee_orange"))
                .fixedSize()
                .navigationTitle("Use UIKit in SwiftUI")
        }
    }
}
```

Creating a preview provider for a `UIView`:

```swift
struct UIKitView_Previews: PreviewProvider {
    static var previews: some View {
        UIKitView()
            .swiftUIView(layout: .intrinsic)
            .set(\.title, to: "This is a UIView")
            .preview(displayName: "A UIKit UIView preview") // A convenience method for creating previews with ease.
    }
}
```

Which results in the following preview:

<img src="Assets/uikit_uiview_preview.png" width="750"/>

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but this SDK does support its use on supported platforms. 

Once you have your Swift package set up, adding the SDK as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/AvdLee/SwiftUIKitView.git", .upToNextMajor(from: "1.0.0"))
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
