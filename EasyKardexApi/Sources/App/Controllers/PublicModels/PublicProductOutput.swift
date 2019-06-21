//
//  PublicProductOutput.swift
//  App
//
//  Created by Marco Estrella on 6/21/19.
//

import Foundation
import Vapor

public struct PublicProductOutput {
    
    let id: Int?
    let productInputID: Int
    let quantity: Int
    let creationDate: Date?
    var creatorID: Int?
}

extension PublicProductOutput: Content {}

extension PublicProductOutput: Codable {
    
    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case productInputID = "idpi"
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
        
        productInputID = try values.decode(Int.self, forKey: .productInputID)
        quantity = try values.decode(Int.self, forKey: .quantity)
        
        if let creatorID = try? values.decode(Int.self, forKey: .creatorID) {
            self.creatorID = creatorID
        } else {
            self.creatorID = nil
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
        try container.encode(productInputID, forKey: .productInputID)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(creatorID, forKey: .creatorID)
        
        guard let creationDate = creationDate else { return }
        
        let creationDataString = DateFormatter.datetime.string(from: creationDate)
        try container.encode(creationDataString, forKey: .creationDate)
    }
}

//MARK: Parsing

extension ProductOutput {
    
    init(from: PublicProductOutput) {
        self.id = from.id
        self.prodInputID = from.productInputID
        self.quantity = from.quantity
        self.creationDate = from.creationDate
        self.creatorID = from.creatorID
    }
    
    public func toPublic() -> PublicProductOutput {
        
        return PublicProductOutput(model: self)
    }
}

extension PublicProductOutput {
    
    init(model: ProductOutput) {
        
        self.id = model.id
        self.productInputID = model.prodInputID
        self.quantity = model.quantity
        self.creationDate = model.creationDate
        self.creatorID = model.creatorID
    }
    
    func toModel() -> ProductOutput {
        return ProductOutput(from: self)
    }
}
