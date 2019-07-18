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

struct User: MySQLModel {
    
    static let entity = "user"

    var id: Int?
    var username: String
    var password: String
    var fullname: String?
    var roleID: Role.ID?
    var creationDate: Date?

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

extension User: FilterableByCreationDate { }

extension User: Publishable {
    
    typealias P = PublicUser
    
    init?(from: PublicUser) {
        
        self.init(id: from.id, username: from.username, password: "", fullname: from.fullname, roleID: from.roleID, creationDate: from.creationDate)
    }
    
    func toPublic() -> PublicUser {
        
        return PublicUser(model: self)
    }
}

extension User: TokenAuthenticatable {
    typealias TokenType = UserToken
}

enum UserType: Int {
    case admin = 1
    case `operator` = 2
}
