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
//  ProductProvider.swift
//  App
//
//  Created by jmarkstar on 6/19/19.
//

import Foundation
import Vapor
import FluentMySQL

struct ProductProvider: MySQLModel {
    
    static let entity = "provider"
    
    var id: Int?
    var companyName: String
    var contactName: String?
    var contactPhoneNumber: String?
    var creationDate: Date?
    var lastUpdateDate: Date?
    var status: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id_provider"
        case companyName = "company_name"
        case contactName = "contact_name"
        case contactPhoneNumber = "contact_phone"
        case creationDate = "creation_date"
        case lastUpdateDate = "last_update_date"
        case status
    }
}

extension ProductProvider: FilterableByLastUpdateDate {}

extension ProductProvider: Validatable {
    
    static func validations() throws -> Validations<ProductProvider> {
        var validations = Validations(ProductProvider.self)
        try validations.add(\.companyName, .count(3...))
        return validations
    }
}

extension ProductProvider: Publishable {
    
    typealias P = PublicProductProvider
    
    init?(from: PublicProductProvider) {
        
        guard let companyName = from.companyName
            else { return nil }
        
        self.init(id: from.id, companyName: companyName, contactName: from.contactName, contactPhoneNumber: from.contactPhone, creationDate: from.creationDate, lastUpdateDate: from.lastUpdateDate, status: from.status)
    }
    
    func toPublic() -> PublicProductProvider {
        
        return PublicProductProvider(model: self)
    }
}
