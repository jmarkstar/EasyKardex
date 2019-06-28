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
//  ProductInputController.swift
//  App
//
//  Created by jmarkstar on 6/20/19.
//

import Vapor
import Fluent

final class ProductInputController: BasicController<ProductInput>, RouteCollection  {
    
    func boot(router: Router) throws {
        
        let inputs = router.authenticated().grouped("inputs")
        
        inputs.get(use: index)
        inputs.get(Int.parameter, use: getById)
        inputs.delete(Int.parameter, use: delete)
        inputs.put(Int.parameter, use: update)
        inputs.post(PublicProductInput.self, use: create)
    }
    
    func create(_ req: Request, newInput: PublicProductInput) throws -> Future<HTTPStatus> {
        let user = try req.requireAuthenticated(User.self)
        
        guard var inputModel = newInput.toModel() else {
            throw Abort(.badRequest)
        }
        
        inputModel.creatorID = user.id
        
        return inputModel.create(on: req).transform(to: .created)
    }
    
    override func index(_ req: Request) throws -> Future<[PublicProductInput]> {
        
        let filters = try req.query.decode(PublicProductInput.self)
        
        let queryBuilder = ProductInput.query(on: req)
        
        if let productId = filters.productID {
            queryBuilder.filter(\.productID == productId)
        }
        
        if let creationDate = filters.creationDate {
            queryBuilder.filter(\.creationDate >= creationDate)
        }
        
        return queryBuilder.all().flatMap { inputs in
            
            return Future.map(on: req) {
                return inputs.map { $0.toPublic() }
            }
        }
    }
    
    /*
    func getById(_ req: Request) throws -> Future<PublicProductInput> {
        
        guard let inputId = try? req.parameters.next(Int.self) else {
            throw Abort(HTTPStatus.badRequest, reason: req.localizedString("input.notid"))
        }
        
        return ProductInput.find(inputId, on: req).flatMap { foundInput in
            
            guard let input = foundInput else {
                throw Abort(HTTPStatus.notFound, reason: req.localizedString("input.notfound"))
            }
            
            return Future.map(on: req) {
                return input.toPublic()
            }
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        
        guard let inputId = try? req.parameters.next(Int.self) else {
            throw Abort(.badRequest, reason: req.localizedString("input.notid"))
        }
        
        return ProductInput.find(inputId, on: req).flatMap(to: Void.self) { foundInput in
            
            guard let input = foundInput else {
                throw Abort(.notFound, reason: req.localizedString("input.notfound"))
            }
            
            return input.delete(on: req)
        }.transform(to: .noContent)
    }
    
    func update(_ req: Request, editedInput: PublicProductInput) throws -> Future<HTTPStatus> {
        
        guard let inputId = try? req.parameters.next(Int.self) else {
            throw Abort(.badRequest, reason: req.localizedString("input.notid"))
        }
        
        return ProductInput.find(inputId, on: req)
            .flatMap(to: ProductInput.self) { foundInput in
                
                guard var input = foundInput else {
                    throw Abort(.notFound, reason: req.localizedString("input.notfound"))
                }
                
                
                
                return input.save(on: req)
        }.transform(to: .noContent)
    }*/
}

extension ProductInput: Updatable {
    
    mutating func loadUpdates(_ from: PublicProductInput) throws {
        
        guard let productID = from.productID,
            let providerID = from.providerID,
            let purchasePrice = from.purchasePrice,
            let expirationDate = from.expirationDate,
            let quantity = from.quantity else {
                throw Abort(.badRequest)
        }
        
        self.productID = productID
        self.providerID = providerID
        self.purchasePrice = purchasePrice
        self.expirationDate = expirationDate
        self.quantity = quantity
    }
}
