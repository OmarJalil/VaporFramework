//
//  UsersController.swift
//  
//
//  Created by Jalil Fierro on 05/07/22.
//

import Vapor
import Fluent

struct UsersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoutes = routes.grouped("api", "users")
        usersRoutes.get(use: getAllHandler)
        usersRoutes.post(use: createHandler)
        usersRoutes.get(":userId", use: getHandler)
        usersRoutes.delete(":userId", use: deleteHandler)
        usersRoutes.put(":userId", use: updateHandler)
        usersRoutes.get(":userId", "acronyms", use: getAcronymsHandler)
    }

    func getAllHandler(_ req: Request) async throws -> [User] {
        return try await User.query(on: req.db).all()
    }

    func createHandler(_ req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        return user.save(on: req.db).map { user }
    }

    func getHandler(_ req: Request) async throws -> User {
        guard let user = try await User.find(req.parameters.get("userId"), on: req.db) else {
            throw Abort(.notFound)
        }
        return user
    }

    func deleteHandler(_ req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(req.parameters.get("userId"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await user.delete(on: req.db)
        return .noContent
    }

    func updateHandler(_ req: Request) async throws -> User {
        let updatedUser = try req.content.decode(User.self)

        guard let user = try await User.find(req.parameters.get("userId"), on: req.db) else {
            throw Abort(.notFound)
        }

        user.name = updatedUser.name
        user.username = updatedUser.username
        try await user.save(on: req.db)
        return user
    }

    func getAcronymsHandler(_ req: Request) async throws -> [Acronym] {
        guard let user = try await User.find(req.parameters.get("userId"), on: req.db) else {
            throw Abort(.notFound)
        }
        return try await user.$acronyms.get(on: req.db)
    }
}
