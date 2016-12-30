//
//  Restaurant.swift
//  FoodPin
//
//  Created by Ziga Besal on 30/12/2016.
//  Copyright © 2016 Ziga Besal. All rights reserved.
//

class Restaurant {
    
    var name = ""
    var type = ""
    var location = ""
    var image = ""
    var visited = false
    
    init(name: String, type: String, location: String, image: String, visited: Bool) {
        self.name = name
        self.type = type
        self.location = location
        self.image = image
        self.visited = visited
    }
    
}
