//
//  Modelable.swift
//  App
//
//  Created by Marco Estrella on 6/25/19.
//

import Foundation
import FluentMySQL

protocol Modelable {
    
    associatedtype M: MySQLModel, Publishable
    
    init(model: M)
    
    func toModel() -> M?
}
