//
// Created by jmarkstar on 19/06/19.
//

import Foundation
import Vapor
import FluentMySQL
import Authentication

final class User: Codable {
    
    static let entity = "user"

    var id: Int?
    var username: String
    var password: String
    var fullname: String?
    var roleID: Role.ID?
    var creationDate: Date?

    init(id: Int? = nil, username: String, password: String, fullname: String? = nil, roleID: Role.ID? = nil, creationDate: Date? = nil) {
        self.id = id
        self.username = username
        self.password = password
        self.fullname = fullname
        self.roleID = roleID
        self.creationDate = creationDate
    }

    enum CodingKeys: String, CodingKey {
        case id = "id_user"
        case username = "username"
        case password = "password"
        case fullname = "fullname"
        case roleID = "id_role"
        case creationDate = "creation_date"
    }
}

extension User {
    
    var role: Parent<User, Role>? {
        return parent(\.roleID)
    }
}

extension User: MySQLModel {}

extension User: TokenAuthenticatable {
    typealias TokenType = UserToken
}

extension User {
    struct UserPublic: Content {
        let id: Int
        let username: String
    }
}

enum UserType: Int {
    case admin = 1
    case `operator` = 2
}
