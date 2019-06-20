//
//  Router.swift
//  App
//
//  Created by Marco Estrella on 6/19/19.
//

import Vapor

extension Router {
    
    public func authenticated() -> Router {
        return self.grouped(AuthenticationMiddleware())
    }
    
    public func adminAuthorizated() -> Router {
        return authenticated().grouped(AdminAuthorizationMiddleware())
    }
}
