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
//  PublicProductCategory.swift
//  App
//
//  Created by jmarkstar on 6/27/19.
//

import Foundation
import Vapor

public struct PublicProductCategory {
    
    let id: Int?
    let name: String?
    let creationDate: Date?
}

extension PublicProductCategory: Content {}

extension PublicProductCategory: Codable {
    
    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case name = "n"
        case creationDate = "cd"
    }
}

extension PublicProductCategory: Modelable {
    
    typealias M = ProductCategory
    
    init(model: ProductCategory) {
        self.id = model.id
        self.name = model.name
        self.creationDate = model.creationDate
    }
    
    func toModel() -> ProductCategory? {
        
        return ProductCategory(from: self)
    }
}
