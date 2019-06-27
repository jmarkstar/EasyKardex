//
//  PublicProductBrand.swift
//  App
//
//  Created by Marco Estrella on 6/24/19.
//

import Foundation
import Vapor
import SimpleFileLogger

public struct PublicProductBrand {
    
    let id: Int?
    let name: String?
    let creationDate: Date?
}

extension PublicProductBrand: Content {}

extension PublicProductBrand: Codable {
    
    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case name = "n"
        case creationDate = "cd"
    }
}

extension PublicProductBrand: Modelable {
    
    typealias M = ProductBrand
    
    init(model: ProductBrand) {
        self.id = model.id
        self.name = model.name
        self.creationDate = model.creationDate
    }
    
    func toModel() -> ProductBrand? {
        
        return ProductBrand(from: self)
    }
}
