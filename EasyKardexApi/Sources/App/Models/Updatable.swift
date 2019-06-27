//
//  Updatable.swift
//  App
//
//  Created by Marco Estrella on 6/27/19.
//

import Foundation
import Vapor

protocol Updatable {
    
    associatedtype P: Content, Modelable
    
    mutating func loadUpdates(_ from: P) throws
}

