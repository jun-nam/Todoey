//
//  ToDoItem.swift
//  Todoey
//
//  Created by June Nam on 8/18/19.
//  Copyright © 2019 Jun Nam. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoItem : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var isDone : Bool = false
    @objc dynamic var dateCreated : Date = Date()
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
