
import Foundation
import Vapor
import FluentMySQL

final class ProductBrand: Codable {

    static let entity = "product_brand"

    var id: Int?
    var name: String

    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }

    enum CodingKeys: String, CodingKey {
        case id = "id_brand"
        case name = "name"
    }
}

extension ProductBrand: MySQLModel {}

extension ProductBrand: Content {}

extension ProductBrand: Parameter {}

