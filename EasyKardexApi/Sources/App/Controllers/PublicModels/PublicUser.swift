//
//  PublicUser.swift
//  App
//
//  Created by Marco Estrella on 7/18/19.
//

import Foundation
import Vapor

public struct PublicUser {
    
    var id: Int?
    var username: String
    var fullname: String?
    var roleID: Role.ID?
    var creationDate: Date?
}

extension PublicUser: Content {}

extension PublicUser: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id = "idu"
        case username = "un"
        case fullname = "fn"
        case roleID = "idr"
        case creationDate = "cd"
    }
}

extension PublicUser: Modelable {
    
    typealias M = User
    
    init(model: User) {
        self.id = model.id
        self.username = model.username
        self.fullname = model.fullname
        self.roleID = model.roleID
        self.creationDate = model.creationDate
    }
    
    func toModel() -> User? {
        
        return User(from: self)
    }
}
