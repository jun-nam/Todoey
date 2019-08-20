//
//  Category.swift
//  Todoey
//
//  Created by June Nam on 8/18/19.
//  Copyright © 2019 Jun Nam. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    
    let items = List<ToDoItem>()
}
