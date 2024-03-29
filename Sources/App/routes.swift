import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: AcronymsController())
    try app.register(collection: UsersController())
    try app.register(collection: CategoriesController())
    try app.register(collection: WebsiteController())
}
