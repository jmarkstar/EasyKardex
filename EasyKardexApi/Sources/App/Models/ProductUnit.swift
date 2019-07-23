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
//  ProductUnit.swift
//  App
//
//  Created by jmarkstar on 6/19/19.
//

import Foundation
import Vapor
import FluentMySQL

struct ProductUnit: MySQLModel {
    
    static let entity = "product_unit"
    
    var id: Int?
    var name: String
    var creationDate: Date?
    var lastUpdateDate: Date?
    var status: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id_unit"
        case name = "name"
        case creationDate = "creation_date"
        case lastUpdateDate = "last_update_date"
        case status
    }
}

extension ProductUnit {
    
    var products: Children<ProductUnit, Product> {
        return children(\.unitID)
    }
}

extension ProductUnit: FilterableByLastUpdateDate {}

extension ProductUnit: Validatable {
    
    static func validations() throws -> Validations<ProductUnit> {
        var validations = Validations(ProductUnit.self)
        try validations.add(\.name, .count(1...))
        return validations
    }
}

extension ProductUnit: Publishable {
    
    typealias P = PublicProductUnit
    
    init?(from: PublicProductUnit) {
        
        guard let name = from.name
            else { return nil }
        
        self.init(id: from.id, name: name, creationDate: from.creationDate, lastUpdateDate: from.lastUpdateDate, status: from.status)
    }
    
    func toPublic() -> PublicProductUnit {
        
        return PublicProductUnit(model: self)
    }
}



