//
//  UIKitView.swift
//  SwiftUIKitExample
//
//  Created by Antoine van der Lee on 28/12/2020.
//

import UIKit
import SwiftUI

/// Previews are easier now too:
struct UIKitView_Previews: PreviewProvider {
    static var previews: some View {
        UIKitView()
            .swiftUIView(layout: .intrinsic)
            .set(\.title, to: "This is a UIView")
            .preview(displayName: "A UIKit UIView preview")
    }
}

/// An example `UIKit` view to demonstrate `SwiftUIKitView`.
/// Represents a simple overlay view with a rounded black background and a text label.
final class UIKitView: UIView {

    private lazy var newLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// The title to display on the overlay.
    var title: String? {
        get {
            newLabel.text
        }
        set {
            newLabel.text = newValue
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()

        print("INIT")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        layer.cornerRadius = 5.0
        layoutMargins = .init(top: 4, left: 10, bottom: 4, right: 10)
        addSubview(newLabel)
        
        NSLayoutConstraint.activate([
            newLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            newLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            layoutMarginsGuide.bottomAnchor.constraint(equalTo: newLabel.bottomAnchor),
            layoutMarginsGuide.trailingAnchor.constraint(equalTo: newLabel.trailingAnchor)
        ])
    }
}
