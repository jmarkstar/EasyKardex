//
//  Provider.swift
//  App
//
//  Created by Marco Estrella on 6/19/19.
//

import Foundation
import Vapor
import FluentMySQL

final class Provider: Codable {
    
    static let entity = "provider"
    
    var id: Int?
    var companyName: String
    var contactName: String
    var contactPhoneNumber: String
    
    init(id: Int? = nil, companyName: String, contactName: String, contactPhoneNumber: String) {
        self.id = id
        self.companyName = companyName
        self.contactName = contactName
        self.contactPhoneNumber = contactPhoneNumber
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id_provider"
        case companyName = "company_name"
        case contactName = "contact_name"
        case contactPhoneNumber = "contact_phone"
    }
}

extension Provider: MySQLModel {}

extension Provider: Content {}
