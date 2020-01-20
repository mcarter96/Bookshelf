// The main screen that the user will see, this is the bookshelf that contains all the covers for the books
//
// The problem that I ran into here was the collection view wasn't populating with the cells and so I wasn't able to view or click on the covers
//  BookshelfViewController.swift
//  BookStore
//
//  Created by admin on 11/13/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class BookshelfViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
       
    @IBOutlet var bookSearch: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    
    let reuseIdentifier = "book"
    var books = [Book]()
    var filteredBooks = [Book]()
    var hasSearched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredBooks = books
        bookSearch.delegate = self
        
        getBooks()
    }
    
    // Will go to the local host and pull the json, then parse the file
    // Parameters: n/a
    // Returns: n/a
    func getBooks(){
        let url = URL(string: "http://localhost:8000/books.json")
        
        guard let jsonData = url else {
            print("Data not found")
            return
        }
        guard let data = try? Data(contentsOf: jsonData) else { return }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
        
        if let dictionary = json as? [String: Any] {
            guard let jsonArray = dictionary["books"] as? [[String: Any?]] else { return }
            if let bookID = dictionary["id"] as? String { print("id is \(bookID)") }
            if let bookTitle = dictionary["title"] as? String { print("title is \(bookTitle)") }
            if let bookAuthor = dictionary["author"] as? String { print("author is \(bookAuthor)") }
            
            
            for item in jsonArray {
                guard let bookID = item["id"] as? String else { return }
                guard let bookTitle = item["title"] as? String else { return }
                guard let bookAuthor = item["author"] as? String else { return }
                books.append(Book(id: bookID, title: bookTitle, author: bookAuthor))
            }
    
        }
    }
    
    // Will search through the books array (the one pulled from server) and if they match the filtered text, will add it to the filtered books array
    // Parameters: searchBar: the search bar element that is being used, searchText: the text in the search bar
    // Returns: n/a
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        hasSearched = true
        filteredBooks = searchText.isEmpty ? books : books.filter { (book: Book) -> Bool in
            return book.title.lowercased().contains(searchText.lowercased()) || book.author.lowercased().contains(searchText.lowercased()) || book.id.lowercased().contains(searchText.lowercased())
        }
        collectionView.reloadData()
    }
    
    // Sets the size for each individual cell in the collection view
    // Parameters: collectionView: the view that contains the cells, collectionViewLayout: the collection view layout associated with the the collection view, indexPath: the cell that will be resized
    // Returns: CGSize: the size of the cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width / 3)-15
        return CGSize(width: width, height: width * 5/3)
    }

    // Gets the count of cells that will be in each section for the collection view
    // Parameters: collectionView: the UI collectionView controller, section: the number of items per section
    // Returns: Int: the number of rows that will appear in the section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filteredBooks.isEmpty && !hasSearched {
            return books.count
        } else {
            return filteredBooks.count
        }
    }
    
    
    // Determines what will be displayed to the cells in the collection view
    // Parameters: collectionView: the view that is being populated, indexPath: the location of the cell
    // Returns: UICollectionViewCell: the cell with information in it
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "book", for: indexPath) as! BookshelfCell
        var imageURLString = ""
        if filteredBooks.isEmpty && !hasSearched {
            imageURLString = books[indexPath.item].imageFile!
        } else {
            imageURLString = filteredBooks[indexPath.item].imageFile!
        }
        let imageURL = URL(string: imageURLString)!
        let imageData = try! Data(contentsOf: imageURL)
        let image = UIImage(data: imageData)
        cell.imageView.image = image
        
        return cell
    }
    
    // Tells the app what cell was selected
    // Parameters: collectionView: the view that is present, indexPath: the location of the cell
    // Returns: n/a
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            print("Could not find cell")
            return
        }
        performSegue(withIdentifier: "DetailSegue", sender: cell)
    }
    
    // Prepares the data from the cell selected to send the details to the details screen
    // Parameters: segue: the segue that is being called, sender: the action that initiates the segue
    // Returns: n/a
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "DetailSegue" {
                if let bookDetailVC = segue.destination as? BookDetailsViewController {
                    let cell = sender as! BookshelfCell
                    let indexPath = collectionView.indexPath(for: cell)
                    let book = filteredBooks[indexPath!.item]
                    bookDetailVC.book = book

                }
            }
        }
    }
    
}
