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
//  Product.swift
//  App
//
//  Created by jmarkstar on 6/19/19.
//

import Foundation
import Vapor
import FluentMySQL
import Authentication

struct Product: MySQLModel {
    
    static let entity = "product"
    
    var id: Int?
    var brandID: ProductBrand.ID
    var categoryID: ProductCategory.ID
    var unitID: ProductUnit.ID
    var name: String
    var image: String?
    var thumb: String?
    var description: String?
    var creationDate: Date?
    var lastUpdateDate: Date?
    var status: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id_prod"
        case brandID = "id_brand"
        case categoryID = "id_category"
        case unitID = "id_unit"
        case name = "name"
        case image = "image"
        case thumb = "thumb"
        case description = "description"
        case creationDate = "creation_date"
        case lastUpdateDate = "last_update_date"
        case status
    }
}

extension Product {
    
    var brand: Parent<Product, ProductBrand>? {
        return parent(\.brandID)
    }
    
    var category: Parent<Product, ProductCategory>? {
        return parent(\.categoryID)
    }
    
    var unit: Parent<Product, ProductUnit>? {
        return parent(\.unitID)
    }
}

extension Product: FilterableByLastUpdateDate { }

extension Product: Validatable {
    
    static func validations() throws -> Validations<Product> {
        var validations = Validations(Product.self)
        try validations.add(\.name, .count(2...))
        return validations
    }
}

extension Product: Publishable {
    
    typealias P = PublicProduct
    
    init?(from: PublicProduct) {
        
        guard let brandId = from.brandId,
            let catId = from.categoryId,
            let unitId = from.unitId,
            let name = from.name
            else { return nil }
        
        self.init(id: from.id, brandID: brandId, categoryID: catId, unitID: unitId,
                  name: name, image: from.image, thumb: from.thumb, description: from.description,
                  creationDate: from.creationDate, lastUpdateDate: from.lastUpdateDate, status: from.status)
    }
    
    func toPublic() -> PublicProduct {
        
        return PublicProduct(model: self)
    }
}




