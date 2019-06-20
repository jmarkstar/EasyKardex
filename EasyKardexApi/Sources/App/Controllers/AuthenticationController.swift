//
// Created by jmarkstar on 19/06/19.
//

import Foundation
import Crypto
import Random
import Vapor
import Fluent

final class AuthenticationController: RouteCollection {

    func boot(router: Router) throws {

        router.post("register", use: register)
        router.post("login", use: login)

        router.authenticated().get("logout", use: logout)
    }

    func register(_ req: Request) throws -> Future<User.UserPublic> {

        return try req.content.decode(User.self).flatMap { user in

            let hasher = try req.make(BCryptDigest.self)
            let passwordHashed = try hasher.hash(user.password)
            
            guard let roleID = user.roleID else {
                throw Abort(HTTPStatus.badRequest)
            }
            
            let newUser = User(username: user.username, password: passwordHashed, fullname: user.fullname, roleID: roleID)

            return newUser.save(on: req).map { storedUser in

                return User.UserPublic(id: try storedUser.requireID(), username: storedUser.username)
            }
        }
    }

    func login(_ req: Request) throws -> Future<UserToken> {

        return try req.content.decode(User.self).flatMap { user in

            return User.query(on: req).filter(\.username == user.username).first().flatMap { fetchedUser in

                guard let existingUser = fetchedUser else {
                    throw Abort(HTTPStatus.notFound)
                }

                let hasher = try req.make(BCryptDigest.self)

                if try hasher.verify(user.password, created: existingUser.password) {

                    return try UserToken
                            .query(on: req)
                            .filter(\UserToken.userID, .equal, existingUser.requireID())
                            .delete()
                            .flatMap { _ in

                        let tokenString = try URandom().generateData(count: 32).base64EncodedString()

                        let token = try UserToken(string: tokenString, userID: existingUser.requireID())
                        return token.save(on: req)
                    }
                } else {

                    throw Abort(.unauthorized)
                }
            }
        }
    }

    func logout(_ req: Request) throws -> Future<HTTPResponse> {
        let user = try req.requireAuthenticated(User.self)
        return try UserToken
                .query(on: req)
                .filter(\UserToken.userID, .equal, user.requireID())
                .delete()
                .transform(to: HTTPResponse(status: .ok))
    }
}
