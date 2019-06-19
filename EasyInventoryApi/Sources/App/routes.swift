import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    try router.register(collection: AuthenticationController())
    try router.register(collection: ProductCategoryController())
    try router.register(collection: ProductBrandController())
}
