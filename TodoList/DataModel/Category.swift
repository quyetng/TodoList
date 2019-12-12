//
//  Category.swift
//  TodoList
//
//  Created by QN on 12/10/19.
//  Copyright © 2019 QN. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    let items = List<Item>()
}
