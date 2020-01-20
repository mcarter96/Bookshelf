// The Book data type that stores the relevant information
//  Book.swift
//  BookStore
//
//  Created by admin on 11/13/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct Book {
    var id: String
    var title: String
    var author: String
    var imageFile: String?
    
    // Initiates the book with the relevant information and sets the location of the cover
    // Parameters: id - the id of the book, title - the title of the book, author
    // Returns: n/a
    init (id: String, title: String, author: String) {
        self.id = id
        self.title = title
        self.author = author
        self.imageFile = "http://localhost:8000/\(id).jpg"
    }
    
}
