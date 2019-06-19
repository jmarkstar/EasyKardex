
import Vapor
import Fluent
import Authentication

//https://theswiftwebdeveloper.com/diving-into-vapor-part-3-introduction-to-routing-and-fluent-in-vapor-3-221d209f1fec
final class ProductBrandController: RouteCollection {

    func boot(router: Router) throws {

        let tokenAuthenticationMiddleware = User.tokenAuthMiddleware()
        let authedROutes = router.grouped(tokenAuthenticationMiddleware)

        let brands = authedROutes.grouped("brands")

        brands.post(use: create)
        brands.get(use: index)
        brands.get(ProductBrand.parameter, use: getById)
        brands.put(ProductBrand.parameter, use: update)
        brands.delete(ProductBrand.parameter, use: delete)
    }

    func index(_ req: Request) throws -> Future<[ProductBrand]> {

        guard let _ = try? req.requireAuthenticated(User.self) else {
            throw Abort(.unauthorized)
        }

        return ProductBrand.query(on: req).all()
    }

    func getById(_ req: Request) throws -> Future<ProductBrand> {

        guard let _ = try? req.requireAuthenticated(User.self) else {
            throw Abort(.unauthorized)
        }

        guard let futureBrand = try? req.parameters.next(ProductBrand.self) else {
            throw Abort(.notFound)
        }
        return futureBrand
    }

    func create(_ req: Request) throws -> Future<ProductBrand> {

        guard let _ = try? req.requireAuthenticated(User.self) else {
            throw Abort(.unauthorized)
        }

        return try req.content.decode(ProductBrand.self).flatMap { brand in
            return brand.save(on: req)
        }
    }

    func update(_ req: Request) throws -> Future<ProductBrand> {

        guard let _ = try? req.requireAuthenticated(User.self) else {
            throw Abort(.unauthorized)
        }

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

    func delete(_ req: Request) throws -> Future<HTTPStatus> {

        guard let _ = try? req.requireAuthenticated(User.self) else {
            throw Abort(.unauthorized)
        }

        guard let futureBrand = try? req.parameters.next(ProductBrand.self) else {
            throw Abort(.badRequest)
        }

        return futureBrand.flatMap { brand in
            return brand.delete(on: req)
        }.transform(to: .ok)
    }
}
