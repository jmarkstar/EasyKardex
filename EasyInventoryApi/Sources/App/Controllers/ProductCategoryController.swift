//
// Created by jmarkstar on 19/06/19.
//

import Foundation
import Vapor
import Fluent

final class ProductCategoryController: RouteCollection {

    func boot(router: Router) throws {

        let tokenAuthenticationMiddleware = User.tokenAuthMiddleware()
        let authedROutes = router.grouped(tokenAuthenticationMiddleware)

        let categories = authedROutes.grouped("categories")

        categories.post(use: create)
        categories.get(use: index)
        categories.get(ProductCategory.parameter, use: getById)
        categories.put(ProductCategory.parameter, use: update)
        categories.delete(ProductCategory.parameter, use: delete)
    }

    func getById(_ req: Request) throws -> Future<ProductCategory> {

        guard let _ = try? req.requireAuthenticated(User.self) else {
            throw Abort(.unauthorized)
        }

        guard let futureCategory = try? req.parameters.next(ProductCategory.self) else {
            throw Abort(.notFound)
        }

        return futureCategory
    }

    func index(_ req: Request) throws -> Future<[ProductCategory]> {

        guard let _ = try? req.requireAuthenticated(User.self) else {
            throw Abort(.unauthorized)
        }

        return ProductCategory.query(on: req).all()
    }

    func create(_ req: Request) throws -> Future<ProductCategory> {

        guard let _ = try? req.requireAuthenticated(User.self) else {
            throw Abort(.unauthorized)
        }

        return try req.content.decode(ProductCategory.self).flatMap { category in
            return category.save(on: req)
        }
    }

    func update(_ req: Request) throws -> Future<ProductCategory> {

        guard let _ = try? req.requireAuthenticated(User.self) else {
            throw Abort(.unauthorized)
        }

        guard let futureCategory = try? req.parameters.next(ProductCategory.self) else {
            throw Abort(.badRequest)
        }

        return try req.content.decode(ProductCategory.self).flatMap { updatedCategory in

            return futureCategory.map(to: ProductCategory.self, { category in

                guard !updatedCategory.name.isEmpty else {
                    throw Abort(.badRequest)
                }

                category.name = updatedCategory.name
                return category
            }).update(on: req)
        }
    }

    func delete(_ req: Request) throws -> Future<HTTPStatus> {

        guard let _ = try? req.requireAuthenticated(User.self) else {
            throw Abort(.unauthorized)
        }

        guard let futureCategory = try? req.parameters.next(ProductCategory.self) else {
            throw Abort(.badRequest)
        }

        return futureCategory.flatMap { category in
            return category.delete(on: req)
        }.transform(to: .ok)
    }
}
