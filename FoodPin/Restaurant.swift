//
//  Restaurant.swift
//  FoodPin
//
//  Created by myron hicks on 2/3/17.
//  Copyright © 2017 myron hicks. All rights reserved.
//

import Foundation

class Restaurant {
    var name = ""
    var type = ""
    var location = ""
    var image = ""
    var phone = ""
    var isVisited = false
    
    init(name: String, type: String, location:String, image: String, phone: String, isVisited:Bool){
        self.name = name;
        self.type = type;
        self.location = location;
        self.image = image;
        self.phone = phone
        self.isVisited = isVisited;
    }
}
