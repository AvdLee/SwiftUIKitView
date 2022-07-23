//
//  IntrinsicContentView.swift
//  
//
//  Created by Antoine van der Lee on 23/07/2022.
//

import Foundation
import UIKit

final class IntrinsicContentView<ContentView: UIView>: UIView {
    let contentView: ContentView
    let layout: Layout

    init(contentView: ContentView, layout: Layout) {
        self.contentView = contentView
        self.layout = layout

        super.init(frame: .zero)
        backgroundColor = .clear
        addSubview(contentView)
    }

    @available(*, unavailable) required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var contentSize: CGSize = .zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    override var intrinsicContentSize: CGSize {
        switch layout {
        case .intrinsic:
            return contentSize
        case .fixedWidth(let width):
            return .init(width: width, height: contentSize.height)
        case .fixed(let size):
            return size
        }
    }

    override var frame: CGRect {
        didSet {
            guard frame != oldValue else { return }

            contentView.frame = self.bounds
            contentView.layoutIfNeeded()

            let targetSize = CGSize(width: frame.width, height: UIView.layoutFittingCompressedSize.height)

            contentSize = contentView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel)
        }
    }
}
