// MIT License
//
// Copyright (c) 2019 Marco Antonio Estrella Cardenas
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
//  ProductInput.swift
//  App
//
//  Created by jmarkstar on 6/19/19.
//

import Foundation
import Vapor
import FluentMySQL

struct ProductInput: MySQLModel {
    
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

extension ProductInput: FilterableByCreationDate {}

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

extension ProductInput: Validatable {
    
    static func validations() throws -> Validations<ProductInput> {
        var validations = Validations(ProductInput.self)
        try validations.add(\.purchasePrice, .range(0.0...))
        try validations.add(\.expirationDate, .range(Date()...))
        try validations.add(\.quantity, .range(1...))
        return validations
    }
}

extension ProductInput: Publishable {
    
    typealias T = PublicProductInput
    
    init?(from: PublicProductInput) {
        self.id = from.id
        
        guard let productID = from.productID,
            let providerID = from.providerID,
            let purchasePrice = from.purchasePrice,
            let expirationDate = from.expirationDate,
            let quantity = from.quantity else {
                return nil
        }
        
        self.productID = productID
        self.providerID = providerID
        self.purchasePrice = purchasePrice
        self.expirationDate = expirationDate
        self.quantity = quantity
        self.creationDate = from.creationDate
        self.creatorID = from.creatorID
    }
    
    public func toPublic() -> PublicProductInput {
        
        return PublicProductInput(model: self)
    }
}

