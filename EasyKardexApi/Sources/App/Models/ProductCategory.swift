//
// Created by jmarkstar on 19/06/19.
//

import Foundation
import Vapor
import FluentMySQL

struct ProductCategory: MySQLModel {

    static let entity = "product_category"

    var id: Int?
    var name: String
    var creationDate: Date?

    enum CodingKeys: String, CodingKey {
        case id = "id_category"
        case name = "name"
        case creationDate = "creation_date"
    }
}

extension ProductCategory {
    
    var products: Children<ProductCategory, Product> {
        return children(\.categoryID)
    }
}

extension ProductCategory: FilterableByCreationDate {}

extension ProductCategory: Validatable {

    static func validations() throws -> Validations<ProductCategory> {
        var validations = Validations(ProductCategory.self)
        try validations.add(\.name, .count(1...))
        return validations
    }
}

extension ProductCategory: Publishable {
    
    typealias P = PublicProductCategory
    
    init?(from: PublicProductCategory) {
        
        guard let name = from.name
            else { return nil }
        
        self.init(id: from.id, name: name, creationDate: from.creationDate)
    }
    
    func toPublic() -> PublicProductCategory {
        
        return PublicProductCategory(model: self)
    }
}

extension ProductCategory: Updatable {
    
    mutating func loadUpdates(_ from: PublicProductCategory) throws {
        
        guard let newName = from.name
            else { throw Abort(.badRequest) }
        
        name = newName
    }
}
