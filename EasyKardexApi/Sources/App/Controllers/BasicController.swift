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
//  BasicController.swift
//  App
//
//  Created by jmarkstar on 6/19/19.
//

import Foundation
import FluentMySQL
import Vapor

class BasicController<M: Publishable> where M: FilterableByLastUpdateDate, M: Validatable, M: Updatable, M.P.M == M {
    
    /** This methodd is able to filter by the last update date.
     * return active and inactive rows.
     */
    func index(_ req: Request) throws -> Future<[M.P]> {
        
        let queryBuilder = M.query(on: req)
        
        if let lastUpdateDateString: String = try req.query.get(at: ["lud"]) {
            let lastUpdateDate = DateFormatter.datetime.date(from: lastUpdateDateString)
            if let lastUpdateDate = lastUpdateDate {
                queryBuilder.filter(\.lastUpdateDate, ._greaterThanOrEqual, lastUpdateDate)
            }
        }
        
        return queryBuilder.all().flatMap(to: [M.P].self ) { models in
            
            return Future.map(on: req) { return models.map { $0.toPublic() } }
        }
    }
    
    /** Only return active rows.
     */
    func getById(_ req: Request) throws -> Future<M.P> {
        
        guard let id = try? req.parameters.next(Int.self) else {
            throw Abort(HTTPStatus.badRequest, reason: req.localizedString("generic.notid"))
        }
        
        return M.query(on: req).filter(\.id, .equal, id).filter(\.status, .equal, 1).first().flatMap { found in
            
            guard let input = found else {
                throw Abort(HTTPStatus.notFound, reason: req.localizedString("generic.notfound"))
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
                throw Abort(.badRequest, reason: req.localizedString("generic.notid"))
            }
            
            try model.validate()
            
            logger.debug("model: \(model)")
            
            return model.save(on: req).flatMap(to: Response.self) { savedModel in
                
                guard let id = savedModel.id else {
                    throw Abort(HTTPStatus.badRequest, reason: req.localizedString("generic.notid"))
                }
                
                return M.find(id, on: req).flatMap { found in
                    
                    guard let modelForReturning = found else {
                        throw Abort(HTTPStatus.notFound, reason: req.localizedString("generic.notfound"))
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
    
    /** The update method will verify if the row is actived in the database according to the filter by id and status. Then, will load the changes, will validate the fields and will update.
     */
    func update(_ req: Request) throws -> Future<Response> {
        
        guard let id = try? req.parameters.next(Int.self) else {
            throw Abort(HTTPStatus.badRequest, reason: req.localizedString("generic.notid"))
        }
        
        return M.query(on: req).filter(\.id, .equal, id).filter(\.status, .equal, 1).first().flatMap(to: Response.self) { foundModel in
            
            guard var foundModel = foundModel else {
                throw Abort(HTTPStatus.notFound, reason: req.localizedString("generic.notfound"))
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
    
    /** The delete method will verify if the row is actived in the database according to the filter by id and status. Then, will change the status's value.
     */
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        
        guard let id = try? req.parameters.next(Int.self) else {
            throw Abort(HTTPStatus.badRequest, reason: req.localizedString("generic.notid"))
        }
        
        return M.query(on: req).filter(\.id, .equal, id).filter(\.status, .equal, 1).first().flatMap(to: HTTPStatus.self) { found in
            
            guard var model = found else {
                throw Abort(HTTPStatus.notFound, reason: req.localizedString("generic.notfound"))
            }
            
            model.status = 0
            
            return model.update(on: req).transform(to: .noContent)
        }
    }
}
