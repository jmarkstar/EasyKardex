//
//  ProviderController.swift
//  App
//
//  Created by Marco Estrella on 6/20/19.
//

import Vapor
import Fluent
/*
final class ProviderController: BasicController<ProductProvider>, RouteCollection {
    
    func boot(router: Router) throws {
        
        let units = router.adminAuthorizated().grouped("providers")
        
        units.post(use: create)
        units.get(use: index)
        units.get(ProductProvider.parameter, use: getById)
        units.put(ProductProvider.parameter, use: update)
        units.delete(ProductProvider.parameter, use: delete)
    }
    
    func update(_ req: Request) throws -> Future<ProductProvider> {
        
        guard let future = try? req.parameters.next(ProductProvider.self) else {
            throw Abort(.badRequest)
        }
        
        return try req.content.decode(ProductProvider.self).flatMap { updated in
            
            return future.map(to: ProductProvider.self, { provider in
                
                provider.companyName = updated.companyName
                provider.contactName = updated.contactName
                provider.contactPhoneNumber = updated.contactPhoneNumber
                return provider
            }).update(on: req)
        }
    }
}*/
