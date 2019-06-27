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
//  AuthenticationMiddleware.swift
//  App
//
//  Created by jmarkstar on 6/19/19.
//

import Foundation
import Vapor
import Fluent

final class AuthenticationMiddleware: Middleware {
    
    func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        
        let logger = try request.make(Logger.self)
        logger.debug(request.description)
        
        guard let bearerAuthorization = request.http.headers.bearerAuthorization else {
            throw Abort(.badRequest, reason: request.localizedString("auth.notheader"))
        }
        
        return UserToken
            .query(on: request)
            .filter(\UserToken.string, .equal, bearerAuthorization.token)
            .first()
            .flatMap { userToken in
                
                guard let userToken = userToken else {
                    throw Abort(.unauthorized, reason: request.localizedString("auth.invalidtoken"))
                }
                
                return User.authenticate(token: userToken, on: request).flatMap { user in
                    
                    guard let user = user else {
                        throw Abort(.unauthorized, reason: request.localizedString("auth.notuser"))
                    }
                    
                    try request.authenticate(user)
                    return try next.respond(to: request)
                }
        }
    }
}
