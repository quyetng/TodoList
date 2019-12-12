//
//  Item.swift
//  TodoList
//
//  Created by QN on 12/10/19.
//  Copyright © 2019 QN. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    @objc dynamic var colorCode: String = ""
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
