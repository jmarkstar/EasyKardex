//
//  PublicUserLoggedIn.swift
//  App
//
//  Created by Marco Estrella on 7/18/19.
//

import Foundation
import Vapor

struct PublicUserLoggedIn {
    let token: String
    let user: PublicUser
}

extension PublicUserLoggedIn: Content {}

extension PublicUserLoggedIn: Codable {
    
    private enum CodingKeys : String, CodingKey {
        case token = "t"
        case user = "u"
    }
}
