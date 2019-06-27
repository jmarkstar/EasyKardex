//
//  PublicProductUnit.swift
//  App
//
//  Created by Marco Estrella on 6/27/19.
//

import Foundation
import Vapor

public struct PublicProductUnit {
    
    let id: Int?
    let name: String?
    let creationDate: Date?
}

extension PublicProductUnit: Content {}

extension PublicProductUnit: Codable {
    
    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case name = "n"
        case creationDate = "cd"
    }
}

extension PublicProductUnit: Modelable {
    
    typealias M = ProductUnit
    
    init(model: ProductUnit) {
        self.id = model.id
        self.name = model.name
        self.creationDate = model.creationDate
    }
    
    func toModel() -> ProductUnit? {
        
        return ProductUnit(from: self)
    }
}
