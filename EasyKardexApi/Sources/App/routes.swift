import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    let routerVersion = router.grouped("v1")
    
    try routerVersion.register(collection: AuthenticationController())
    try routerVersion.register(collection: ProductCategoryController())
    try routerVersion.register(collection: ProductBrandController())
}

extension Router {

    public func authenticated() -> Router {
        return self.grouped(AuthenticationMiddleware())
    }
    
    public func adminAuthorizated() -> Router {
        return authenticated().grouped(AdminAuthorizationMiddleware())
    }
}
