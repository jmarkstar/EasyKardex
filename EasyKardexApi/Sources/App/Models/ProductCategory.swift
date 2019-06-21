//
// Created by jmarkstar on 19/06/19.
//

import Foundation
import Vapor
import FluentMySQL

final class ProductCategory: Codable {

    static let entity = "product_category"

    var id: Int?
    var name: String
    var creationDate: Date?

    init(id: Int? = nil, name: String, creationDate: Date? = nil) {
        self.id = id
        self.name = name
        self.creationDate = creationDate
    }

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

extension ProductCategory: MySQLModel {}

extension ProductCategory: Content {}

extension ProductCategory: Parameter {}
