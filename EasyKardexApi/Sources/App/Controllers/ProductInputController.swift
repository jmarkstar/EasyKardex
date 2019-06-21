//
//  ProductInputController.swift
//  App
//
//  Created by Marco Estrella on 6/20/19.
//

import Vapor
import Fluent

final class ProductInputController: RouteCollection {
    
    func boot(router: Router) throws {
        
        let inputs = router.authenticated().grouped("inputs")
        
        inputs.get(use: getAll)
        inputs.get(Int.parameter, use: getById)
        inputs.delete(Int.parameter, use: delete)
        inputs.put(PublicProductInput.self, at: Int.parameter, use: update)
        inputs.post(PublicProductInput.self, use: create)
    }
    
    func create(_ req: Request, newInput: PublicProductInput) throws -> Future<HTTPStatus> {
        
        let inputModel = newInput.toModel()
        
        return inputModel.create(on: req).transform(to: .created)
    }
    
    func getAll(_ req: Request) throws -> Future<[PublicProductInput]> {
        
        return ProductInput.query(on: req).all().flatMap { inputs in
            
            /*guard inputs.count > 0 else {
                throw Abort(HTTPStatus.noContent, reason: "There is not inputs")
            }*/
            
            return Future.map(on: req) {
                return inputs.map { $0.toPublic() }
            }
        }
    }
    
    func getById(_ req: Request) throws -> Future<PublicProductInput> {
        
        guard let inputId = try? req.parameters.next(Int.self) else {
            throw Abort(HTTPStatus.badRequest, reason: req.localizedString("input.notid"))
        }
        
        return ProductInput.find(inputId, on: req).flatMap { foundInput in
            
            guard let input = foundInput else {
                throw Abort(HTTPStatus.badRequest, reason: "Users doesnt exists")
            }
            
            return Future.map(on: req) {
                return input.toPublic()
            }
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        
        guard let inputId = try? req.parameters.next(Int.self) else {
            throw Abort(HTTPStatus.badRequest, reason: req.localizedString("input.notid"))
        }
        
        return ProductInput.find(inputId, on: req).flatMap(to: Void.self) { foundInput in
            
            guard let input = foundInput else {
                throw Abort(HTTPStatus.badRequest, reason: "Users doesnt exists")
            }
            
            return input.delete(on: req)
        }.transform(to: .noContent)
    }
    
    func update(_ req: Request, editedInput: PublicProductInput) throws -> Future<HTTPStatus> {
        
        guard let inputId = try? req.parameters.next(Int.self) else {
            throw Abort(HTTPStatus.badRequest, reason: req.localizedString("input.notid"))
        }
        
        return ProductInput.find(inputId, on: req)
            .flatMap(to: ProductInput.self) { foundInput in
                
                guard var input = foundInput else {
                    throw Abort(HTTPStatus.badRequest, reason: "Users doesnt exists")
                }
                
                input.productID = editedInput.productID
                input.providerID = editedInput.providerID
                input.purchasePrice = editedInput.purchasePrice
                input.expirationDate = editedInput.expirationDate
                input.quantity = editedInput.quantity
                
                return input.save(on: req)
        }.transform(to: .noContent)
    }
}
