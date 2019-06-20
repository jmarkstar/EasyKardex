//
// Created by jmarkstar on 19/06/19.
//

import Vapor
import Fluent
import Authentication

final class ProductBrandController: BasicController<ProductBrand>, RouteCollection {

    func boot(router: Router) throws {

        let brands = router.adminAuthorizated().grouped("brands")

        brands.post(use: create)
        brands.get(use: index)
        brands.get(ProductBrand.parameter, use: getById)
        brands.put(ProductBrand.parameter, use: update)
        brands.delete(ProductBrand.parameter, use: delete)
    }

    func update(_ req: Request) throws -> Future<ProductBrand> {

        guard let futureBrand = try? req.parameters.next(ProductBrand.self) else {
            throw Abort(.badRequest)
        }

        return try req.content.decode(ProductBrand.self).flatMap { updatedBrand in

            return futureBrand.map(to: ProductBrand.self, { brand in

                guard !updatedBrand.name.isEmpty else {
                    throw Abort(.badRequest)
                }

                brand.name = updatedBrand.name
                return brand
            }).update(on: req)
        }
    }
}
