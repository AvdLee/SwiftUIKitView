//
//  KeyPathReferenceWritable.swift
//
//
//  Created by Antoine van der Lee on 28/12/2020.
//

import Foundation

/// Defines a type that is configurable using reference writeable keypaths.
///
/// Example usage:
/// 
/// UILabel()
///    .set(\.text, to: "Example")

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
