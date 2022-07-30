//
//  ModifiedUIViewContainer.swift
//  
//
//  Created by Antoine van der Lee on 23/07/2022.
//

import Foundation
import SwiftUI
import UIKit

@dynamicMemberLookup
public struct ModifiedUIViewContainer<ChildContainer: UIViewContaining, Child, Value>: UIViewContaining where ChildContainer.Child == Child {

    let child: ChildContainer
    let keyPath: ReferenceWritableKeyPath<Child, Value>
    let value: Value

    public func makeCoordinator() -> UIViewContainingCoordinator<Child> {
        child.makeCoordinator() as! UIViewContainingCoordinator<Child>
    }

    public func makeUIView(context: Context) -> IntrinsicContentView<Child> {
        context.coordinator.createView()
    }

    public func updateUIView(_ uiView: IntrinsicContentView<Child>, context: Context) {
        update(uiView.contentView, coordinator: context.coordinator, updateContentSize: true)
    }

    public func update(_ uiView: Child, coordinator: UIViewContainingCoordinator<Child>, updateContentSize: Bool) {
        uiView[keyPath: keyPath] = value
        child.update(uiView, coordinator: coordinator, updateContentSize: false)

        if updateContentSize {
            coordinator.view?.updateContentSize()
        }
    }
    
    public subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<Child, Value>) -> (Value) -> ModifiedUIViewContainer<Self, Child, Value> {
        { self.set(keyPath, to: $0) }
    }
}

