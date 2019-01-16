//
//  Item.swift
//  todosy
//
//  Created by bharath on 2018/12/13.
//  Copyright © 2018 bharath. All rights reserved.
//

import Foundation
import RealmSwift


class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var createdTime : Date?
    
    //defining backward relationship to make class as type using .self 
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
