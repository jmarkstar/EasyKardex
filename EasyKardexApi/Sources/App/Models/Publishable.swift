//
//  Publishable.swift
//  App
//
//  Created by Marco Estrella on 6/24/19.
//

import Foundation
import Vapor

protocol Publishable {
    
    associatedtype P: Content, Modelable
    
    init?(from: P)
    
    func toPublic() -> P
}
