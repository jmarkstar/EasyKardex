//
//  BasicController.swift
//  App
//
//  Created by Marco Estrella on 6/19/19.
//

import Foundation
import FluentMySQL
import Vapor

open class BasicController<T: MySQLModel> where T: Parameter {
    
    func index(_ req: Request) throws -> Future<[T]> {
        
        return T.query(on: req).all()
    }
    
    func getById(_ req: Request) throws -> Future<T> {
        
        guard let future = try? req.parameters.next(T.self) else {
            throw Abort(.notFound)
        }
        return future as! EventLoopFuture<T>
    }
    
    func create(_ req: Request) throws -> Future<T> {
        
        return try req.content.decode(T.self).flatMap { brand in
            return brand.save(on: req)
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        
        guard let futureBrand = try? req.parameters.next(T.self) else {
            throw Abort(.badRequest)
        }
        
        return (futureBrand as! EventLoopFuture<T>).flatMap { brand in
            return brand.delete(on: req)
            }.transform(to: .ok)
    }
}
