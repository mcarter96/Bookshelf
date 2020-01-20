// A simple screen to show the details of the book that was selected from the bookshelf screen
//  BookDetailsViewController.swift
//  BookStore
//
//  Created by admin on 11/13/19.
//  Copyright © 2019 Apple. All rights reserved.
//


import UIKit

class BookDetailsViewController: UIViewController {
    
    var book: Book? = nil
    
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Sets the information on the Book details scren
        if let book = book {
            idLabel.text = book.id
            titleLabel.text = book.title
            authorLabel.text = book.author
            print(book)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
