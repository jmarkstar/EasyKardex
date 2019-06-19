//
// Created by jmarkstar on 19/06/19.
// https://medium.com/@martinlasek/tutorial-how-to-build-bearer-auth-8ae3f80b9522
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

