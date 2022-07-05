//
//  Category.swift
//  
//
//  Created by Jalil Fierro on 05/07/22.
//

import Fluent
import Vapor

final class Category: Model {
    static let schema = "categories"

    @ID
    var id: UUID?

    @Field(key: "name")
    var name: String

    init() {}

    init(id: UUID? = nil, name: String, username: String) {
        self.id = id
        self.name = name
    }
}

extension Category: Content {

}
