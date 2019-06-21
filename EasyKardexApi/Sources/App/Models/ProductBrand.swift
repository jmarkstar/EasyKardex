
import Foundation
import Vapor
import FluentMySQL

final class ProductBrand: Codable {

    static let entity = "product_brand"

    var id: Int?
    var name: String
    var creationDate: Date?

    init(id: Int? = nil, name: String, creationDate: Date? = nil) {
        self.id = id
        self.name = name
        self.creationDate = creationDate
    }

    enum CodingKeys: String, CodingKey {
        case id = "id_brand"
        case name = "name"
        case creationDate = "creation_date"
    }
}

extension ProductBrand {
    
    var products: Children<ProductBrand, Product> {
        return children(\.brandID)
    }
}

extension ProductBrand: MySQLModel {}

extension ProductBrand: Content {}

extension ProductBrand: Parameter {}

