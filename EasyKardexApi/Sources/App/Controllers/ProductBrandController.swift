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
        brands.get(Int.parameter, use: getById)
        brands.put(Int.parameter, use: update)
        brands.delete(Int.parameter, use: delete)
    }
}
