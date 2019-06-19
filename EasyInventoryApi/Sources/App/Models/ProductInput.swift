//
//  ProductInput.swift
//  App
//
//  Created by Marco Estrella on 6/19/19.
//

import Foundation
import Vapor
import FluentMySQL

final class ProductInput: Codable {
    
    static let entity = "product_input"
    
    var id: Int?
    var productID: Product.ID
    var providerID: Provider.ID
    var purchasePrice: Float
    var expirationDate: Date
    var quantity: Int
    var creationData: Date?
    var creatorID: User.ID?
    
    init(id: Int? = nil,
         productID: Product.ID,
         providerID: Provider.ID,
         purchasePrice: Float,
         expirationDate: Date,
         quantity: Int,
         creationData: Date? = nil,
         creatorID: User.ID? = nil) {
        
        self.id = id
        self.productID = productID
        self.providerID = providerID
        self.purchasePrice = purchasePrice
        self.expirationDate = expirationDate
        self.quantity = quantity
        self.creationData = creationData
        self.creatorID = creatorID
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id_input"
        case productID = "id_prod"
        case providerID = "id_provider"
        case purchasePrice = "purchase_price"
        case expirationDate = "expiration_date"
        case quantity = "quantity"
        case creationData = "creation_data"
        case creatorID = "creation_user_id"
    }
}

extension ProductInput {
    
    var product: Parent<ProductInput, Product> {
        return parent(\.productID)
    }
    
    var provider: Parent<ProductInput, Provider> {
        return parent(\.providerID)
    }
    
    var creator: Parent<ProductInput, User>? {
        return parent(\.creatorID)
    }
}

extension ProductInput: MySQLModel {}

extension ProductInput {
    struct InputPublic: Content {
        let id: Int
    }
}
