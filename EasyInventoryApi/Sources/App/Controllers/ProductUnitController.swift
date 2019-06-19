//
//  ProductUnitController.swift
//  App
//
//  Created by Marco Estrella on 6/19/19.
//

import Vapor
import Fluent
import Authentication

final class ProductUnitController: RouteCollection {
    
    func boot(router: Router) throws {
        
        let tokenAuthenticationMiddleware = User.tokenAuthMiddleware()
        let authedROutes = router.grouped(tokenAuthenticationMiddleware)
        
        let units = authedROutes.grouped("units")
        
        units.post(use: create)
        units.get(use: index)
        units.get(ProductUnit.parameter, use: getById)
        units.put(ProductUnit.parameter, use: update)
        units.delete(ProductUnit.parameter, use: delete)
    }
    
    func index(_ req: Request) throws -> Future<[ProductUnit]> {
        
        guard try req.isAuthenticated(User.self) else {
            throw Abort(.unauthorized)
        }
        
        return ProductUnit.query(on: req).all()
    }
    
    func getById(_ req: Request) throws -> Future<ProductUnit> {
        
        guard try req.isAuthenticated(User.self) else {
            throw Abort(.unauthorized)
        }
        
        guard let future = try? req.parameters.next(ProductUnit.self) else {
            throw Abort(.notFound)
        }
        return future
    }
    
    func create(_ req: Request) throws -> Future<ProductUnit> {
        
        guard try req.isAuthenticated(User.self) else {
            throw Abort(.unauthorized)
        }
        
        return try req.content.decode(ProductUnit.self).flatMap { brand in
            return brand.save(on: req)
        }
    }
    
    func update(_ req: Request) throws -> Future<ProductUnit> {
        
        guard try req.isAuthenticated(User.self) else {
            throw Abort(.unauthorized)
        }
        
        guard let future = try? req.parameters.next(ProductUnit.self) else {
            throw Abort(.badRequest)
        }
        
        return try req.content.decode(ProductUnit.self).flatMap { updated in
            
            return future.map(to: ProductUnit.self, { unit in
                
                guard !updated.name.isEmpty else {
                    throw Abort(.badRequest)
                }
                
                unit.name = updated.name
                return unit
            }).update(on: req)
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        
        guard try req.isAuthenticated(User.self) else {
            throw Abort(.unauthorized)
        }
        
        guard let future = try? req.parameters.next(ProductUnit.self) else {
            throw Abort(.badRequest)
        }
        
        return future.flatMap { unit in
            return unit.delete(on: req)
            }.transform(to: .ok)
    }
}

