//
//  ProductUnit.swift
//  App
//
//  Created by Marco Estrella on 6/19/19.
//

import Foundation
import Vapor
import FluentMySQL

final class ProductUnit: Codable {
    
    static let entity = "product_unit"
    
    var id: Int?
    var name: String
    var creationDate: Date?
    
    init(id: Int? = nil, name: String, creationDate: Date? = nil) {
        self.id = id
        self.name = name
        self.creationDate = creationDate
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id_unit"
        case name = "name"
        case creationDate = "creation_date"
    }
}

extension ProductUnit {
    
    var products: Children<ProductUnit, Product> {
        return children(\.unitID)
    }
}

extension ProductUnit: MySQLModel {}

extension ProductUnit: Content {}

extension ProductUnit: Parameter {}
