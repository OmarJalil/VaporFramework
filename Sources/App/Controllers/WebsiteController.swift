//
//  WebsiteController.swift
//  
//
//  Created by Jalil Fierro on 11/07/22.
//

import Vapor

struct WebsiteController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get(use: indexHandler)
    }

    func indexHandler(_ req: Request) async throws -> View {
        let context = IndexContext(title: "Homepage")
        return try await req.view.render("index", context)
    }
}

struct IndexContext: Encodable {
    let title: String
}
