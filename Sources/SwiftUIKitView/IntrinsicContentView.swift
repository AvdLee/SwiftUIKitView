//
//  IntrinsicContentView.swift
//  
//
//  Created by Antoine van der Lee on 23/07/2022.
//

import Foundation
import UIKit

public final class IntrinsicContentView<ContentView: UIView>: UIView {
    let contentView: ContentView
    let layout: Layout

    init(contentView: ContentView, layout: Layout) {
        self.contentView = contentView
        self.layout = layout

        super.init(frame: .zero)
        backgroundColor = .clear
        addSubview(contentView)
        clipsToBounds = true
    }

    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var contentSize: CGSize = .zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    public override var intrinsicContentSize: CGSize {
        switch layout {
        case .intrinsic:
            return contentSize
        case .fixedWidth(let width):
            return .init(width: width, height: contentSize.height)
        case .fixed(let size):
            return size
        }
    }

    public func updateContentSize() {
        switch layout {
        case .fixedWidth(let width):
            // Set the frame of the cell, so that the layout can be updated.
            var newFrame = contentView.frame
            newFrame.size = CGSize(width: width, height: UIView.layoutFittingExpandedSize.height)
            contentView.frame = newFrame

            // Make sure the contents of the cell have the correct layout.
            contentView.setNeedsLayout()
            contentView.layoutIfNeeded()

            // Get the size of the cell
            let computedSize = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

            // Apple: "Only consider the height for cells, because the contentView isn't anchored correctly sometimes." We use ceil to make sure we get rounded numbers and no half pixels.
            contentSize = CGSize(width: width, height: ceil(computedSize.height))
        case .fixed(let size):
            contentSize = size
        case .intrinsic:
            contentSize = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        }
    }
}
