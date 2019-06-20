
import FluentMySQL
import Vapor
import Authentication
import LingoVapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Providers
    try services.register(FluentMySQLProvider())
    try services.register(MySQLProvider())
    try services.register(AuthenticationProvider())
    
    let lingoProvider = LingoProvider(defaultLocale: "en", localizationsDir: "Localizations")
    try services.register(lingoProvider)

    let mysqlConfig = MySQLDatabaseConfig(
            hostname: "127.0.0.1",
            port: 3306,
            username: "root",
            password: "root",
            database: "easy_kardex_db"
    )

    let mysql = MySQLDatabase(config: mysqlConfig)

    var databases = DatabasesConfig()
    databases.add(database: mysql, as: .mysql)
    databases.enableLogging(on: .mysql)
    services.register(databases)

    //Models for existing tables

    User.defaultDatabase = .mysql
    UserToken.defaultDatabase = .mysql
    Role.defaultDatabase = .mysql
    ProductBrand.defaultDatabase = .mysql
    ProductCategory.defaultDatabase = .mysql
    ProductUnit.defaultDatabase = .mysql
    Product.defaultDatabase = .mysql
    Provider.defaultDatabase = .mysql
    ProductInput.defaultDatabase = .mysql
    ProductOutput.defaultDatabase = .mysql
}
