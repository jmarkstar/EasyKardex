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
//  PublicProductOutput.swift
//  App
//
//  Created by jmarkstar on 6/21/19.
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

extension PublicProductOutput: Modelable {
    
    init(model: ProductOutput) {
        
        self.id = model.id
        self.productInputID = model.prodInputID
        self.quantity = model.quantity
        self.creationDate = model.creationDate
        self.creatorID = model.creatorID
    }
    
    func toModel() -> ProductOutput? {
        return ProductOutput(from: self)
    }
}
