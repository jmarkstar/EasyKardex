//
//  ProductProvider.swift
//  App
//
//  Created by Marco Estrella on 6/19/19.
//

import Foundation
import Vapor
import FluentMySQL

struct ProductProvider: MySQLModel {
    
    static let entity = "provider"
    
    var id: Int?
    var companyName: String
    var contactName: String
    var contactPhoneNumber: String
    var creationDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case id = "id_provider"
        case companyName = "company_name"
        case contactName = "contact_name"
        case contactPhoneNumber = "contact_phone"
        case creationDate = "creation_date"
    }
}

extension ProductProvider: FilterableByCreationDate {}


