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
//  ProviderController.swift
//  App
//
//  Created by jmarkstar on 6/20/19.
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
