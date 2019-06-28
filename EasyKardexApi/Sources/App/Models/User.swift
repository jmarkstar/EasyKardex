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
