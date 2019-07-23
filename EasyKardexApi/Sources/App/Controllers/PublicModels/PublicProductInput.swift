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
//  PublicProductInput.swift
//  App
//
//  Created by jmarkstar on 6/20/19.
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
    var lastUpdateDate: Date?
    var status: Int?
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
        case lastUpdateDate = "lud"
        case status = "s"
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
        self.lastUpdateDate = model.lastUpdateDate
        self.status = model.status
    }
    
    func toModel() -> ProductInput? {
        return ProductInput(from: self)
    }
}
