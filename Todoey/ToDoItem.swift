//
//  ToDoItem.swift
//  Todoey
//
//  Created by June Nam on 8/11/19.
//  Copyright © 2019 Jun Nam. All rights reserved.
//

import Foundation

class ToDoItem {
    
    var title : String = ""
    var isDone : Bool = false
    
    init(description : String) {
        self.title = description
    }
    
    init(description : String, isDone: Bool) {
        self.title = description
        self.isDone = isDone
    }
}
