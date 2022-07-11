//
//  CategoriesController.swift
//  
//
//  Created by Jalil Fierro on 05/07/22.
//

import Vapor
import Fluent

struct CategoriesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let categoriesRoutes = routes.grouped("api", "categories")
        categoriesRoutes.get(use: getAllHandler)
        categoriesRoutes.post(use: createHandler)
        categoriesRoutes.get(":categoryId", use: getHandler)
        categoriesRoutes.delete(":categoryId", use: deleteHandler)
        categoriesRoutes.put(":categoryId", use: updateHandler)
        categoriesRoutes.get(":categoryId", "acronyms", use: getAcronymsHandler)
    }

    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Category]> {
        Category.query(on: req.db).all()
    }

    func createHandler(_ req: Request) throws -> EventLoopFuture<Category> {
        let category = try req.content.decode(Category.self)
        return category.save(on: req.db).map { category }
    }

    func getHandler(_ req: Request) throws -> EventLoopFuture<Category> {
        Category.find(req.parameters.get("categoryId"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }

    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Category.find(req.parameters.get("categoryId"), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap { category in
                category.delete(on: req.db).transform(to: .noContent)
            }
    }

    func updateHandler(_ req: Request) throws -> EventLoopFuture<Category> {
        let updatedCategory = try req.content.decode(Category.self)
        return Category.find(req.parameters.get("categoryId"), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap { category in
                category.name = updatedCategory.name
                return category.save(on: req.db).map {
                    category
                }
            }
    }

    func getAcronymsHandler(_ req: Request) throws -> EventLoopFuture<[Acronym]> {
        Category.find(req.parameters.get("categoryId"), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap { category in
                category.$acronyms.get(on: req.db)
            }
    }
}
