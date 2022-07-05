//
//  AcronymsController.swift
//  
//
//  Created by Jalil Fierro on 01/07/22.
//

import Vapor
import Fluent

struct AcronymsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let acronymsRoutes = routes.grouped("api", "acronyms")
        acronymsRoutes.get(use: getAllHandler)
        acronymsRoutes.post(use: createHandler)
        acronymsRoutes.get(":acronymId", use: getHandler)
        acronymsRoutes.delete(":acronymId", use: deleteHandler)
        acronymsRoutes.put(":acronymId", use: updateHandler)
        acronymsRoutes.get(":acronymId", "user", use: getUserHandler)
    }

    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Acronym]> {
        Acronym.query(on: req.db).all()
    }

    func createHandler(_ req: Request) throws -> EventLoopFuture<Acronym> {
        let data = try req.content.decode(CreateAcronymData.self)
        let acronym = Acronym(short: data.short, long: data.long, userId: data.userId)
        return acronym.save(on: req.db).map { acronym }
    }

    func getHandler(_ req: Request) throws -> EventLoopFuture<Acronym> {
        Acronym.find(req.parameters.get("acronymId"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }

    func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Acronym.find(req.parameters.get("acronymId"), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap { acronym in
                acronym.delete(on: req.db).transform(to: .noContent)
            }
    }

    func updateHandler(_ req: Request) throws -> EventLoopFuture<Acronym> {
        let updatedAcronym = try req.content.decode(Acronym.self)
        return Acronym.find(req.parameters.get("acronymId"), on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap { acronym in
                acronym.short = updatedAcronym.short
                acronym.long = updatedAcronym.long
                return acronym.save(on: req.db).map {
                    acronym
                }
            }
    }

    func getUserHandler(_ req: Request) throws -> EventLoopFuture<User> {
        Acronym.find(req.parameters.get("acronymId"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { acronym in
            acronym.$user.get(on: req.db)
        }
    }
}

struct CreateAcronymData: Content {
    let short: String
    let long: String
    let userId: UUID
}
