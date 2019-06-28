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

final class ProductOutputController: BasicController<ProductOutput>, RouteCollection {
    
    func boot(router: Router) throws {
        
        let outputs = router.authenticated().grouped("outputs")
        
        outputs.get(use: index)
        outputs.get(Int.parameter, use: getById)
        outputs.delete(Int.parameter, use: delete)
        outputs.put(Int.parameter, use: update)
        outputs.post(PublicProductOutput.self, use: create)
    }
    
    func create(_ req: Request, newInput: PublicProductOutput) throws -> Future<HTTPStatus> {
        let user = try req.requireAuthenticated(User.self)
        
        guard var inputModel = newInput.toModel() else {
            throw Abort(.badRequest)
        }
        
        inputModel.creatorID = user.id
        
        return inputModel.create(on: req).transform(to: .created)
    }
}

extension ProductOutput: Updatable {
    
    mutating func loadUpdates(_ from: PublicProductOutput) throws {

        self.prodInputID = from.productInputID
        self.quantity = from.quantity
    }
}
