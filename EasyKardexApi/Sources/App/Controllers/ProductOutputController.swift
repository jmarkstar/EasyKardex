//
//  ProductOutputController.swift
//  App
//
//  Created by Marco Estrella on 6/20/19.
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
