//
// Created by jmarkstar on 19/06/19.
//

import Foundation
import Vapor
import Fluent
/*
final class ProductCategoryController: BasicController<ProductCategory>, RouteCollection {

    func boot(router: Router) throws {

        let categories = router.adminAuthorizated().grouped("categories")

        categories.post(use: create)
        categories.get(use: index)
        categories.get(ProductCategory.parameter, use: getById)
        categories.put(ProductCategory.parameter, use: update)
        categories.delete(ProductCategory.parameter, use: delete)
    }
    
    func update(_ req: Request) throws -> Future<ProductCategory> {

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
}
*/
