//
//  Product.swift
//  App
//
//  Created by Marco Estrella on 6/19/19.
//

import Foundation
import Vapor
import FluentMySQL
import Authentication

struct Product: FilterableByCreationDate {
    
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

extension Product: MySQLModel {}


