//
//  PublicProductInput.swift
//  App
//
//  Created by Marco Estrella on 6/20/19.
//
// I parsed it manually because I should manage 2 defferent format of Dates.
// expirationDate = yyyy-MM-dd and creationDate yyyy-MM-dd HH:mm:ss
//

import Foundation
import Vapor

public struct PublicProductInput {
    
    let id: Int?
    let productID: Int?
    let providerID: Int?
    let purchasePrice: Float?
    let expirationDate: Date?
    let quantity: Int?
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
        
        if let productID = try? values.decode(Int.self, forKey: .productID) {
            self.productID = productID
        } else {
            self.productID = nil
        }
        
        if let providerID = try? values.decode(Int.self, forKey: .providerID) {
            self.providerID = providerID
        } else {
            self.providerID = nil
        }
        
        if let purchasePrice = try? values.decode(Float.self, forKey: .purchasePrice) {
            self.purchasePrice = purchasePrice
        } else {
            self.purchasePrice = nil
        }
        
        if let quantity = try? values.decode(Int.self, forKey: .quantity) {
            self.quantity = quantity
        } else {
            self.quantity = nil
        }
        
        if let creatorID = try? values.decode(Int.self, forKey: .creatorID) {
            self.creatorID = creatorID
        } else {
            self.creatorID = nil
        }
        
        if let expirationDateString = try? values.decode(String.self, forKey: .expirationDate) {
            expirationDate = DateFormatter.normalDate.date(from: expirationDateString)!
        } else {
            self.expirationDate = nil
        }
        
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
        
        if let expirationDate = expirationDate {
            let expirationDateString = DateFormatter.normalDate.string(from: expirationDate)
            try container.encode(expirationDateString, forKey: .expirationDate)
        }
    
        if let creationDate = creationDate {
            let creationDataString = DateFormatter.datetime.string(from: creationDate)
            try container.encode(creationDataString, forKey: .creationDate)
        }
    }
}

//MARK: Parsing

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

extension PublicProductInput: Modelable {
    
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
    
    func toModel() -> ProductInput? {
        return ProductInput(from: self)
    }
}
