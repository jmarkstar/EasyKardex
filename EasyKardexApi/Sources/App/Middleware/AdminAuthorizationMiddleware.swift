//
//  AdminAuthorizationMiddleware.swift
//  App
//
//  Created by Marco Estrella on 6/19/19.
//

import Foundation

import Vapor
import Fluent

final class AdminAuthorizationMiddleware: Middleware {
    
    func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {

        guard let user = try? request.requireAuthenticated(User.self) else {
            throw Abort(.unauthorized)
        }
        
        guard let userRole = user.userRole, userRole == .admin else {
            throw Abort(.unauthorized)
        }
        
        return try next.respond(to: request)
    }
}
