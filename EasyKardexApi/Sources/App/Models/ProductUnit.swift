//
//  ProductUnit.swift
//  App
//
//  Created by Marco Estrella on 6/19/19.
//

import Foundation
import Vapor
import FluentMySQL

struct ProductUnit: MySQLModel {
    
    static let entity = "product_unit"
    
    var id: Int?
    var name: String
    var creationDate: Date?
    
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

extension ProductUnit: FilterableByCreationDate {}

extension ProductUnit: Validatable {
    
    static func validations() throws -> Validations<ProductUnit> {
        var validations = Validations(ProductUnit.self)
        try validations.add(\.name, .count(1...))
        return validations
    }
}

extension ProductUnit: Publishable {
    
    typealias P = PublicProductUnit
    
    init?(from: PublicProductUnit) {
        
        guard let name = from.name
            else { return nil }
        
        self.init(id: from.id, name: name, creationDate: from.creationDate)
    }
    
    func toPublic() -> PublicProductUnit {
        
        return PublicProductUnit(model: self)
    }
}

extension ProductUnit: Updatable {
    
    mutating func loadUpdates(_ from: PublicProductUnit) throws {
        
        guard let newName = from.name
            else { throw Abort(.badRequest) }
        
        name = newName
    }
}



