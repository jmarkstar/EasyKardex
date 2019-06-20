//
//  ProductInputController.swift
//  App
//
//  Created by Marco Estrella on 6/20/19.
//

import Vapor
import Fluent

final class ProductInputController: BasicController<ProductInput>, RouteCollection {
    
    func boot(router: Router) throws {
        
        let inputs = router.adminAuthorizated().grouped("inputs")
        
        inputs.post(use: create)
        inputs.get(use: index)
        inputs.get(ProductInput.parameter, use: getById)
        inputs.put(ProductInput.parameter, use: update)
        inputs.delete(ProductInput.parameter, use: delete)
    }
    
    func update(_ req: Request) throws -> Future<ProductInput> {
        
        guard let future = try? req.parameters.next(ProductInput.self) else {
            throw Abort(.badRequest)
        }
        
        return try req.content.decode(ProductInput.self).flatMap { updated in
            
            return future.map(to: ProductInput.self, { item in
                
                //provider.companyName = updated.companyName
                //provider.contactName = updated.contactName
                //provider.contactPhoneNumber = updated.contactPhoneNumber
                return item
            }).update(on: req)
        }
    }
}
