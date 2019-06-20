//
//  ProductOutput.swift
//  App
//
//  Created by Marco Estrella on 6/19/19.
//

import Foundation
import Vapor
import FluentMySQL

final class ProductOutput: Codable {
    
    static let entity = "product_output"
    
    var id: Int?
    var prodInputID: ProductInput.ID
    var quantity: Int
    var creationData: Date?
    var creatorID: User.ID?
    
    init(id: Int? = nil,
         prodInputID: ProductInput.ID,
         quantity: Int,
         creationData: Date? = nil,
         creatorID: User.ID? = nil) {
        self.id = id
        self.prodInputID = prodInputID
        self.quantity = quantity
        self.creationData = creationData
        self.creatorID = creatorID
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id_output"
        case prodInputID = "id_product_input"
        case quantity = "quantity"
        case creationData = "creation_data"
        case creatorID = "creation_user_id"
    }
}

extension ProductOutput {
    
    var productInput: Parent<ProductOutput, ProductInput> {
        return parent(\.prodInputID)
    }
    
    var creator: Parent<ProductOutput, User>? {
        return parent(\.creatorID)
    }
}

extension ProductOutput: MySQLModel {}

extension ProductOutput: Parameter {}

extension ProductOutput: Content {}

extension ProductOutput {
    struct OutputPublic: Content {
        let id: Int
        let username: String
    }
}
