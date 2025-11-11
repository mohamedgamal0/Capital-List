//
//  DomainConvertible.swift
//  Capital List
//
//  Created by Mohamed Gamal on 11/11/2025.
//

import Foundation

public protocol DomainConvertible {
    associatedtype Output
    func toDomain() -> Output
}

