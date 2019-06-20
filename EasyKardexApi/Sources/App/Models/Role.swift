//
//  Role.swift
//  App
//
//  Created by Marco Estrella on 6/19/19.
//

import Foundation
import Vapor
import FluentMySQL

final class Role: Codable {
    
    static let entity = "role"
    
    var id: Int?
    var name: String
    
    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id_role"
        case name = "name"
    }
}

extension Role: MySQLModel {}

extension Role: Content {}
