//
//  AcronymCategoryPivot.swift
//  
//
//  Created by Jalil Fierro on 11/07/22.
//

import Fluent
import Foundation

final class AcronymCategoryPivot: Model {
    static let schema = "acronym-category-pivot"

    @ID
    var id: UUID?

    @Parent(key: "acronymId")
    var acronym: Acronym

    @Parent(key: "categoryId")
    var category: Category

    init() {}

    init(id: UUID? = nil, acronym: Acronym, category: Category) throws {
        self.id = id
        self.$acronym.id = try acronym.requireID()
        self.$category.id = try category.requireID()
    }
}
