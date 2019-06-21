//
//  ProductInput.swift
//  App
//
//  Created by Marco Estrella on 6/19/19.
//

import Foundation
import Vapor
import FluentMySQL

struct ProductInput: Codable {
    
    static let entity = "product_input"
    
    var id: Int?
    var productID: Product.ID
    var providerID: ProductProvider.ID
    var purchasePrice: Float
    var expirationDate: Date
    var quantity: Int
    var creationDate: Date?
    var creatorID: User.ID?
    
    enum CodingKeys: String, CodingKey {
        case id = "id_input"
        case productID = "id_prod"
        case providerID = "id_provider"
        case purchasePrice = "purchase_price"
        case expirationDate = "expiration_date"
        case quantity = "quantity"
        case creationDate = "creation_date"
        case creatorID = "creation_user_id"
    }
}

extension ProductInput: MySQLModel {}

extension ProductInput {
    
    var product: Parent<ProductInput, Product> {
        return parent(\.productID)
    }
    
    var provider: Parent<ProductInput, ProductProvider> {
        return parent(\.providerID)
    }
    
    var creator: Parent<ProductInput, User>? {
        return parent(\.creatorID)
    }
    
    var outputs: Children<ProductInput, ProductOutput> {
        return children(\.prodInputID)
    }
}

