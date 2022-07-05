//
//  CreateAcronym.swift
//  
//
//  Created by Jalil Fierro on 01/07/22.
//

import Fluent

struct CreateAcronym: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Acronym.schema)
            .id()
            .field("short", .string, .required)
            .field("long", .string, .required)
            .field("userId", .uuid, .required, .references(User.schema, "id"))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Acronym.schema).delete()
    }
}
