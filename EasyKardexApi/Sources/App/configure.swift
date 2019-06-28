// MIT License
//
// Copyright (c) 2019 Marco Antonio Estrella Cardenas
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


import FluentMySQL
import Vapor
import Authentication
import LingoVapor
import SimpleFileLogger

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
    
    var contentConfig = ContentConfig.default()
    let jsonDecoder = JSONDecoder()
    let jsonEncoder = JSONEncoder()
    jsonEncoder.dateEncodingStrategy = .formatted(.datetime)

    jsonDecoder.dateDecodingStrategyFormatters = [ DateFormatter.iso8601,
                                            DateFormatter.datetime,
                                            DateFormatter.normalDate ]
    
    contentConfig.use(decoder: jsonDecoder, for: .json)
    contentConfig.use(encoder: jsonEncoder, for: .json)
    services.register(contentConfig)
    
    try services.register(FluentMySQLProvider())
    try services.register(AuthenticationProvider())
    
    let lingoProvider = LingoProvider(defaultLocale: "en")
    try services.register(lingoProvider)
    
    services.register(Logger.self) { container -> SimpleFileLogger in
        
        return SimpleFileLogger(executableName: "EasyKardexApi", includeTimestamps: true)
    }
    
    config.prefer(SimpleFileLogger.self, for: Logger.self)

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
    ProductProvider.defaultDatabase = .mysql
    ProductInput.defaultDatabase = .mysql
    ProductOutput.defaultDatabase = .mysql
}
