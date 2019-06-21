//
//  ProductOutput.swift
//  App
//
//  Created by Marco Estrella on 6/19/19.
//

import Foundation
import Vapor
import FluentMySQL

struct ProductOutput: Codable {
    
    static let entity = "product_output"
    
    var id: Int?
    var prodInputID: ProductInput.ID
    var quantity: Int
    var creationDate: Date?
    var creatorID: User.ID?
    
    init(id: Int? = nil,
         prodInputID: ProductInput.ID,
         quantity: Int,
         creationDate: Date? = nil,
         creatorID: User.ID? = nil) {
        self.id = id
        self.prodInputID = prodInputID
        self.quantity = quantity
        self.creationDate = creationDate
        self.creatorID = creatorID
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id_output"
        case prodInputID = "id_product_input"
        case quantity = "quantity"
        case creationDate = "creation_data"
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
