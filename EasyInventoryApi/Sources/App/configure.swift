
import FluentMySQL
import Vapor
import Authentication

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a MySQL database
    try services.register(FluentMySQLProvider())
    try services.register(MySQLProvider())
    try services.register(AuthenticationProvider())

    let mysqlConfig = MySQLDatabaseConfig(
            hostname: "127.0.0.1",
            port: 3306,
            username: "root",
            password: "abc123",
            database: "small_business_db"
    )

    let mysql = MySQLDatabase(config: mysqlConfig)

    var databases = DatabasesConfig()
    databases.add(database: mysql, as: .mysql)
    databases.enableLogging(on: .mysql)
    services.register(databases)

    //Models for existing tables

    ProductBrand.defaultDatabase = .mysql
    ProductCategory.defaultDatabase = .mysql
    User.defaultDatabase = .mysql
    UserToken.defaultDatabase = .mysql

    // Configure migrations
    //var migrations = MigrationConfig()
    //migrations.add(model: ProductBrand.self, database: .mysql)
    //services.register(migrations)

}
