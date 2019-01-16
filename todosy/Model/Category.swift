//
//  Category.swift
//  todosy
//
//  Created by bharath on 2018/12/13.
//  Copyright © 2018 bharath. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    
    let items = List<Item>()
}
