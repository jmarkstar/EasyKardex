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
//  ProductOutputController.swift
//  App
//
//  Created by jmarkstar on 6/20/19.
//

import Vapor
import Fluent

final class ProductOutputController: RouteCollection {
    
    func boot(router: Router) throws {
        
        let outputs = router.authenticated().grouped("outputs")
        
        outputs.get(use: getAll)
        outputs.get(Int.parameter, use: getById)
        outputs.delete(Int.parameter, use: delete)
        outputs.put(PublicProductOutput.self, at: Int.parameter, use: update)
        outputs.post(PublicProductOutput.self, use: create)
    }
    
    func create(_ req: Request, newInput: PublicProductOutput) throws -> Future<HTTPStatus> {
        let user = try req.requireAuthenticated(User.self)
        
        var inputModel = newInput.toModel()
        inputModel.creatorID = user.id
        
        return inputModel.create(on: req).transform(to: .created)
    }
    
    func getAll(_ req: Request) throws -> Future<[PublicProductOutput]> {
        
        return ProductOutput.query(on: req).all().flatMap { inputs in
            
            return Future.map(on: req) {
                return inputs.map { $0.toPublic() }
            }
        }
    }
    
    func getById(_ req: Request) throws -> Future<PublicProductOutput> {
        
        guard let inputId = try? req.parameters.next(Int.self) else {
            throw Abort(HTTPStatus.badRequest, reason: req.localizedString("output.notid"))
        }
        
        return ProductOutput.find(inputId, on: req).flatMap { foundOutput in
            
            guard let output = foundOutput else {
                throw Abort(HTTPStatus.notFound, reason: req.localizedString("output.notfound"))
            }
            
            return Future.map(on: req) {
                return output.toPublic()
            }
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        
        guard let inputId = try? req.parameters.next(Int.self) else {
            throw Abort(.badRequest, reason: req.localizedString("output.notid"))
        }
        
        return ProductOutput.find(inputId, on: req).flatMap(to: Void.self) { foundOutput in
            
            guard let output = foundOutput else {
                throw Abort(.notFound, reason: req.localizedString("output.notfound"))
            }
            
            return output.delete(on: req)
            }.transform(to: .noContent)
    }
    
    func update(_ req: Request, editedOutput: PublicProductOutput) throws -> Future<HTTPStatus> {
        
        guard let inputId = try? req.parameters.next(Int.self) else {
            throw Abort(.badRequest, reason: req.localizedString("output.notid"))
        }
        
        return ProductOutput.find(inputId, on: req)
            .flatMap(to: ProductOutput.self) { foundOutput in
                
                guard var output = foundOutput else {
                    throw Abort(.notFound, reason: req.localizedString("output.notfound"))
                }
                
                output.prodInputID = editedOutput.productInputID
                output.quantity = editedOutput.quantity
                
                return output.save(on: req)
            }.transform(to: .noContent)
    }
}
