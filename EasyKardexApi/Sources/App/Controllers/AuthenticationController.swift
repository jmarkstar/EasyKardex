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
