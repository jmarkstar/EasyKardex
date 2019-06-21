//
//  ProductOutputController.swift
//  App
//
//  Created by Marco Estrella on 6/20/19.
//

import Vapor
import Fluent

final class ProductOutputController: BasicController<ProductOutput>, RouteCollection {
    
    func boot(router: Router) throws {
        
        let outputs = router.authenticated().grouped("outputs")
        
        outputs.post(use: create)
        outputs.get(use: index)
        outputs.get(ProductOutput.parameter, use: getById)
        outputs.put(ProductOutput.parameter, use: update)
        outputs.delete(ProductOutput.parameter, use: delete)
    }
    
    func update(_ req: Request) throws -> Future<ProductOutput> {
        
        guard let future = try? req.parameters.next(ProductOutput.self) else {
            throw Abort(.badRequest)
        }
        
        return try req.content.decode(ProductOutput.self).flatMap { updated in
            
            return future.map(to: ProductOutput.self, { item in
                
                //provider.companyName = updated.companyName
                //provider.contactName = updated.contactName
                //provider.contactPhoneNumber = updated.contactPhoneNumber
                return item
            }).update(on: req)
        }
    }
}
