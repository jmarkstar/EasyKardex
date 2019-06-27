//
//  ProductUnitController.swift
//  App
//
//  Created by Marco Estrella on 6/19/19.
//

import Vapor
import Fluent
/*
final class ProductUnitController: BasicController<ProductUnit>, RouteCollection {
    
    func boot(router: Router) throws {
        
        let units = router.adminAuthorizated().grouped("units")
        
        units.post(use: create)
        units.get(use: index)
        units.get(ProductUnit.parameter, use: getById)
        units.put(ProductUnit.parameter, use: update)
        units.delete(ProductUnit.parameter, use: delete)
    }
    
    func update(_ req: Request) throws -> Future<ProductUnit> {
        
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
}*/

