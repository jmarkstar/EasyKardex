//
//  PublicProductInput.swift
//  App
//
//  Created by Marco Estrella on 6/20/19.
//

import Foundation
import Vapor

public struct PublicProductInput {
    
    let id: Int?
    let productID: Int
    let providerID: Int
    let purchasePrice: Float
    let expirationDate: Date
    let quantity: Int
    let creationDate: Date?
    var creatorID: Int?
}

extension PublicProductInput: Content {}

extension PublicProductInput: Codable {
    
    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case productID = "idpd"
        case providerID = "idpv"
        case purchasePrice = "pp"
        case expirationDate = "ed"
        case quantity = "q"
        case creationDate = "cd"
        case creatorID = "cuid"
    }
    
    public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let id = try? values.decode(Int.self, forKey: .id) {
            self.id = id
        } else {
            self.id = nil
        }
        
        productID = try values.decode(Int.self, forKey: .productID)
        providerID = try values.decode(Int.self, forKey: .providerID)
        purchasePrice = try values.decode(Float.self, forKey: .purchasePrice)
        quantity = try values.decode(Int.self, forKey: .quantity)
        
        if let creatorID = try? values.decode(Int.self, forKey: .creatorID) {
            self.creatorID = creatorID
        } else {
            self.creatorID = nil
        }
        
        let expirationDateString = try values.decode(String.self, forKey: .expirationDate)
        expirationDate = DateFormatter.normalDate.date(from: expirationDateString)!
        
        if let creationDataString = try? values.decode(String.self, forKey: .creationDate) {
            creationDate = DateFormatter.datetime.date(from: creationDataString)
        } else {
            creationDate = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(productID, forKey: .productID)
        try container.encode(providerID, forKey: .providerID)
        try container.encode(purchasePrice, forKey: .purchasePrice)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(creatorID, forKey: .creatorID)
        
        let expirationDateString = DateFormatter.normalDate.string(from: expirationDate)
        try container.encode(expirationDateString, forKey: .expirationDate)
        
        guard let creationDate = creationDate else { return }
        
        let creationDataString = DateFormatter.datetime.string(from: creationDate)
        try container.encode(creationDataString, forKey: .creationDate)
    }
}

//MARK: Parsing

extension ProductInput {
    
    init(from: PublicProductInput) {
        self.id = from.id
        self.productID = from.productID
        self.providerID = from.providerID
        self.purchasePrice = from.purchasePrice
        self.expirationDate = from.expirationDate
        self.quantity = from.quantity
        self.creationDate = from.creationDate
        self.creatorID = from.creatorID
    }
    
    public func toPublic() -> PublicProductInput {
        
        return PublicProductInput(model: self)
    }
}

extension PublicProductInput {
    
    init(model: ProductInput) {
        
        self.id = model.id
        self.productID = model.productID
        self.providerID = model.providerID
        self.purchasePrice = model.purchasePrice
        self.expirationDate = model.expirationDate
        self.quantity = model.quantity
        self.creationDate = model.creationDate
        self.creatorID = model.creatorID
    }
    
    func toModel() -> ProductInput {
        return ProductInput.init(from: self)
    }
}
