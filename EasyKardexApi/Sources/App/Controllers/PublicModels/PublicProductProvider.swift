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
//  PublicProductProvider.swift
//  App
//
//  Created by jmarkstar on 6/27/19.
//

import Foundation
import Vapor

public struct PublicProductProvider {
    
    let id: Int?
    let companyName: String?
    let contactName: String?
    let contactPhone: String?
    let creationDate: Date?
}

extension PublicProductProvider: Content {}

extension PublicProductProvider: Codable {
    
    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case companyName = "cpn"
        case contactName = "cn"
        case contactPhone = "cp"
        case creationDate = "cd"
    }
}

extension PublicProductProvider: Modelable {
    
    typealias M = ProductProvider
    
    init(model: ProductProvider) {
        self.id = model.id
        self.companyName = model.companyName
        self.contactName = model.contactName
        self.contactPhone = model.contactPhoneNumber
        self.creationDate = model.creationDate
    }
    
    func toModel() -> ProductProvider? {
        
        return ProductProvider(from: self)
    }
}
