//
//  CreateAcronymCategoryPivot.swift
//  
//
//  Created by Jalil Fierro on 11/07/22.
//

import Fluent

struct CreateAcronymCategoryPivot: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(AcronymCategoryPivot.schema)
            .id()
            .field("acronymId", .uuid, .required, .references(Acronym.schema, "id", onDelete: .cascade))
            .field("categoryId", .uuid, .required, .references(Category.schema, "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(AcronymCategoryPivot.schema).delete()
    }
}
