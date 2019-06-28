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

final class UserToken: Codable {

    static let entity = "user_token"

    var id: Int?
    var string: String
    var userID: User.ID

    init(id: Int? = nil, string: String, userID: User.ID) {
        self.id = id
        self.string = string
        self.userID = userID
    }

    enum CodingKeys: String, CodingKey {
        case id = "id_token"
        case string = "string"
        case userID = "id_user"
    }
}

extension UserToken {

    var user: Parent<UserToken, User> {
        return parent(\.userID)
    }
}

extension UserToken: MySQLModel {}

extension UserToken: Content {}

extension UserToken: BearerAuthenticatable {
    static var tokenKey: WritableKeyPath<UserToken, String> { return \.string }
}

extension UserToken: Token {

    typealias UserType = User
    typealias UserIDType = User.ID

    static var userIDKey: WritableKeyPath<UserToken, User.ID> {
        return \.userID
    }
}

