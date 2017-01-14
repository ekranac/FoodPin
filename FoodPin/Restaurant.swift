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
    var phone = ""
    var image = ""
    var rating = ""
    var isVisited = false
    
    init(name: String, type: String, location: String, phone: String, image: String, isVisited: Bool) {
        self.name = name
        self.type = type
        self.location = location
        self.phone = phone
        self.image = image
        self.isVisited = isVisited
    }
    
}
