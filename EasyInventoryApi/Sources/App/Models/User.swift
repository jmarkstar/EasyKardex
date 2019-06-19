//
// Created by jmarkstar on 19/06/19.
// Check this link: https://medium.com/@martinlasek/tutorial-how-to-build-bearer-auth-8ae3f80b9522
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

    init(id: Int? = nil, username: String, password: String, fullname: String?) {
        self.id = id
        self.username = username
        self.password = password
        self.fullname = fullname
    }

    enum CodingKeys: String, CodingKey {
        case id = "id_user"
        case username = "username"
        case password = "password"
        case fullname = "fullname"
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