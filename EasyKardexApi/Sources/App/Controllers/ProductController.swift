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
//  ProductController.swift
//  App
//
//  Created by jmarkstar on 6/20/19.
//

import Vapor
import Fluent

final class ProductController: BasicController<Product>, RouteCollection {
    
    func boot(router: Router) throws {
        
        let products = router.adminAuthorizated().grouped("products")
        
        products.post(use: create)
        products.get(use: index)
        products.get(Int.parameter, use: getById)
        products.put(Int.parameter, use: update)
        products.delete(Int.parameter, use: delete)
    }
}

extension Product: Updatable {
    
    mutating func loadUpdates(_ from: PublicProduct) throws {
        
        guard let newName = from.name
            else { throw Abort(.badRequest) }
        
        name = newName
    }
}
