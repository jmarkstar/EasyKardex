//
//  ProductController.swift
//  App
//
//  Created by Marco Estrella on 6/20/19.
//

import Vapor
import Fluent

final class ProductController: BasicController<Product>, RouteCollection {
    
    func boot(router: Router) throws {
        
        let products = router.adminAuthorizated().grouped("products")
        
        products.post(use: create)
        products.get(use: index)
        products.get(Product.parameter, use: getById)
        products.put(Product.parameter, use: update)
        products.delete(Product.parameter, use: delete)
    }
    
    func update(_ req: Request) throws -> Future<Product> {
        
        guard let future = try? req.parameters.next(Product.self) else {
            throw Abort(.badRequest)
        }
        
        return try req.content.decode(Product.self).flatMap { updated in
            
            return future.map(to: Product.self, { item in
                
                //provider.companyName = updated.companyName
                //provider.contactName = updated.contactName
                //provider.contactPhoneNumber = updated.contactPhoneNumber
                return item
            }).update(on: req)
        }
    }
}
