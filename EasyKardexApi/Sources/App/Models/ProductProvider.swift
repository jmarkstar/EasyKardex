//
//  ProductProvider.swift
//  App
//
//  Created by Marco Estrella on 6/19/19.
//

import Foundation
import Vapor
import FluentMySQL

final class ProductProvider: Codable {
    
    static let entity = "provider"
    
    var id: Int?
    var companyName: String
    var contactName: String
    var contactPhoneNumber: String
    var creationDate: Date?
    
    init(id: Int? = nil, companyName: String, contactName: String, contactPhoneNumber: String, creationDate: Date? = nil) {
        self.id = id
        self.companyName = companyName
        self.contactName = contactName
        self.contactPhoneNumber = contactPhoneNumber
        self.creationDate = creationDate
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id_provider"
        case companyName = "company_name"
        case contactName = "contact_name"
        case contactPhoneNumber = "contact_phone"
        case creationDate = "creation_date"
    }
}

extension ProductProvider: MySQLModel {}

extension ProductProvider: Content {}

extension ProductProvider: Parameter {}
