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
    }

    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[User]> {
        User.query(on: req.db).all()
    }

    func createHandler(_ req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        return user.save(on: req.db).map { user }
    }

    func getHandler(_ req: Request) throws -> EventLoopFuture<User> {
        User.find(req.parameters.get("userId"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }

    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        User.find(req.parameters.get("userId"), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap { user in
                user.delete(on: req.db).transform(to: .noContent)
            }
    }

    func updateHandler(_ req: Request) throws -> EventLoopFuture<User> {
        let updatedUser = try req.content.decode(User.self)
        return User.find(req.parameters.get("userId"), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap { user in
                user.name = updatedUser.name
                user.username = updatedUser.username
                return user.save(on: req.db).map {
                    user
                }
            }
    }
}
