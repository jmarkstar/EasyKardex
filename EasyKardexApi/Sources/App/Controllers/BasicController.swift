//
//  BasicController.swift
//  App
//
//  Created by Marco Estrella on 6/19/19.
//

import Foundation
import FluentMySQL
import Vapor

class BasicController<M: Publishable> where M: FilterableByCreationDate, M: Validatable, M: Updatable, M.P.M == M {
    
    /** This methodd is able to filter by creation date.
     */
    func index(_ req: Request) throws -> Future<[M.P]> {
        
        let queryBuilder = M.query(on: req)
        
        if let creationDateString: String = try req.query.get(at: ["cd"]) {
            let creationDate = DateFormatter.datetime.date(from: creationDateString)
            if let creationDate = creationDate {
                queryBuilder.filter(\.creationDate, ._greaterThanOrEqual, creationDate)
            }
        }
        
        return queryBuilder.all().flatMap(to: [M.P].self ) { models in
            
            return Future.map(on: req) { return models.map { $0.toPublic() } }
        }
    }
    
    
    func getById(_ req: Request) throws -> Future<M.P> {
        
        guard let id = try? req.parameters.next(Int.self) else {
            throw Abort(HTTPStatus.badRequest, reason: req.localizedString("input.notid"))
        }
        
        return M.find(id, on: req).flatMap { found in
            
            guard let input = found else {
                throw Abort(HTTPStatus.notFound, reason: req.localizedString("input.notfound"))
            }
            
            return Future.map(on: req) {
                return input.toPublic()
            }
        }
    }
    
    
    func create(_ req: Request) throws -> Future<Response> {
        
        return try req.content.decode(M.P.self).flatMap(to: Response.self) { content in
            
            let logger = try req.make(Logger.self)
            
            guard let model = content.toModel() else {
                throw Abort(.badRequest, reason: req.localizedString("input.notid"))
            }
            
            try model.validate()
            
            logger.debug("model: \(model)")
            
            return model.save(on: req).flatMap(to: Response.self) { savedModel in
                
                guard let id = savedModel.id else {
                    throw Abort(HTTPStatus.badRequest, reason: req.localizedString("input.notid"))
                }
                
                return M.find(id, on: req).flatMap { found in
                    
                    guard let modelForReturning = found else {
                        throw Abort(HTTPStatus.notFound, reason: req.localizedString("input.notfound"))
                    }
                    
                    let response = Response(http: HTTPResponse(status: .created), using: req)
                    try response.content.encode(modelForReturning.toPublic(), as: .json)
                    
                    return Future.map(on: req) {
                        return response
                    }
                }
            }
        }
    }
    
    func update(_ req: Request) throws -> Future<Response> {
        
        guard let id = try? req.parameters.next(Int.self) else {
            throw Abort(HTTPStatus.badRequest, reason: req.localizedString("input.notid"))
        }
        
        return M.find(id, on: req).flatMap(to: Response.self) { foundModel in
            
            guard var foundModel = foundModel else {
                throw Abort(HTTPStatus.notFound, reason: req.localizedString("input.notfound"))
            }
            
            return try req.content.decode(M.P.self).flatMap(to: Response.self) { content in
                
                try foundModel.loadUpdates(content)
                
                try foundModel.validate()
                
                return foundModel.update(on: req).flatMap(to: Response.self) { _ in
                    
                    let response = Response(http: HTTPResponse(status: .ok), using: req)
                    try response.content.encode(foundModel.toPublic(), as: .json)
                    
                    return Future.map(on: req) {
                        return response
                    }
                }
            }
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        
        guard let id = try? req.parameters.next(Int.self) else {
            throw Abort(HTTPStatus.badRequest, reason: req.localizedString("input.notid"))
        }
        
        return M.find(id, on: req).flatMap(to: HTTPStatus.self) { found in
            
            guard let model = found else {
                throw Abort(HTTPStatus.notFound, reason: req.localizedString("input.notfound"))
            }
            
            return model.delete(on: req).transform(to: .noContent)
        }
    }
}
