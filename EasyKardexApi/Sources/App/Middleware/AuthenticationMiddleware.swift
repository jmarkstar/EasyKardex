


//
//  AuthenticationMiddleware.swift
//  App
//
//  Created by Marco Estrella on 6/19/19.
//

import Foundation
import Vapor
import Fluent

final class AuthenticationMiddleware: Middleware {
    
    func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        
        guard let bearerAuthorization = request.http.headers.bearerAuthorization else {
            throw Abort(.badRequest)
        }
        
        return UserToken
            .query(on: request)
            .filter(\UserToken.string, .equal, bearerAuthorization.token)
            .first()
            .flatMap { userToken in
                
                guard let userToken = userToken else {
                    throw Abort(.unauthorized)
                }
                
                return User.authenticate(token: userToken, on: request).flatMap { user in
                    
                    guard let user = user else {
                        throw Abort(.unauthorized)
                    }
                    
                    try request.authenticate(user)
                    return try next.respond(to: request)
                }
        }
    }
}
