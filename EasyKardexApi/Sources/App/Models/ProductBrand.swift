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
//  ProductBrand.swift
//  App
//
//  Created by jmarkstar on 6/19/19.
//

import Foundation
import Vapor
import FluentMySQL

struct ProductBrand: MySQLModel {
    
    static let entity = "product_brand"
    
    var id: Int?
    var name: String
    var creationDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case id = "id_brand"
        case name = "name"
        case creationDate = "creation_date"
    }
}

extension ProductBrand {
    
    var products: Children<ProductBrand, Product> {
        return children(\.brandID)
    }
}

extension ProductBrand: FilterableByCreationDate { }

extension ProductBrand: Validatable {
    
    static func validations() throws -> Validations<ProductBrand> {
        var validations = Validations(ProductBrand.self)
        try validations.add(\.name, .count(1...))
        return validations
    }
}

extension ProductBrand: Publishable {
    
    typealias P = PublicProductBrand
    
    init?(from: PublicProductBrand) {
        
        guard let name = from.name
            else { return nil }
        
        self.init(id: from.id, name: name, creationDate: from.creationDate)
    }
    
    func toPublic() -> PublicProductBrand {
        
        return PublicProductBrand(model: self)
    }
}

