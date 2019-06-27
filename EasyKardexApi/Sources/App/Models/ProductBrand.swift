
import Foundation
import Vapor
import FluentMySQL

struct ProductBrand: MySQLModel {
    
    static let entity = "product_brand"
    
    var id: Int?
    var name: String
    var creationDate: Date?
    
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

extension ProductBrand: FilterableByCreationDate { }

extension ProductBrand: Validatable {
    
    static func validations() throws -> Validations<ProductBrand> {
        var validations = Validations(ProductBrand.self)
        try validations.add(\.name, .count(1...))
        return validations
    }
}

extension ProductBrand: Publishable {
    
    typealias P = PublicProductBrand
    
    init?(from: PublicProductBrand) {
        
        guard let name = from.name
            else { return nil }
        
        self.init(id: from.id, name: name, creationDate: from.creationDate)
    }
    
    func toPublic() -> PublicProductBrand {
        
        return PublicProductBrand(model: self)
    }
}

extension ProductBrand: Updatable {

    mutating func loadUpdates(_ from: PublicProductBrand) throws {
        
        guard let newName = from.name
            else { throw Abort(.badRequest) }
        
        name = newName
    }
}

