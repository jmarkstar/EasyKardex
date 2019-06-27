//
//  PublicProductCategory.swift
//  App
//
//  Created by Marco Estrella on 6/27/19.
//

import Foundation
import Vapor

public struct PublicProductCategory {
    
    let id: Int?
    let name: String?
    let creationDate: Date?
}

extension PublicProductCategory: Content {}

extension PublicProductCategory: Codable {
    
    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case name = "n"
        case creationDate = "cd"
    }
}

extension PublicProductCategory: Modelable {
    
    typealias M = ProductCategory
    
    init(model: ProductCategory) {
        self.id = model.id
        self.name = model.name
        self.creationDate = model.creationDate
    }
    
    func toModel() -> ProductCategory? {
        
        return ProductCategory(from: self)
    }
}
