//
//  NotesVC.swift
//
//  Created by Ranjana on 2021-05-24.
//

import UIKit
import CoreData

class NotesVC: UITableViewController , addNote{
    // create notes
    var notes = [Note]()
    var selectedCategory : Category? {
        didSet {
            loadNotes()
        }
    }
    // create the context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // define a search controller
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = selectedCategory?.catName
        showSearchBar()

    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note_cell", for: indexPath)
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.noteTitle
        cell.textLabel?.textColor = .lightGray
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .darkGray
        cell.selectedBackgroundView = backgroundView

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNote(note: notes[indexPath.row])
            saveNotes()
            notes.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /// delete notes from context
    /// - Parameter note: note defined in Core Data
    func deleteNote(note: Note) {
        context.delete(note)
    }
    
    /// update note in core data
    /// - Parameter title: note's title
    func updateNote( title: String,descrption :String) {
        notes = []
        let newNote = Note(context: context)
        newNote.noteTitle = title
        newNote.noteDescription = descrption
        newNote.category = selectedCategory
      
        saveNotes()
        loadNotes()
    }
    
    /// Save notes into core data
    func saveNotes() {
        do {
            try context.save()
        } catch {
            print("Error saving the notes \(error.localizedDescription)")
        }
    }
    //MARK: - show search bar func
    func showSearchBar() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Note"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.searchTextField.textColor = .lightGray
    }

    
    
    //MARK: - Core data interaction functions
    
    /// load notes deom core data
    /// - Parameter predicate: parameter comming from search bar - by default is nil
    func loadNotes(predicate: NSPredicate? = nil) {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let folderPredicate = NSPredicate(format: "category.catName=%@", selectedCategory!.catName!)
        request.sortDescriptors = [NSSortDescriptor(key: "noteTitle", ascending: true)]
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [folderPredicate, additionalPredicate])
        } else {
            request.predicate = folderPredicate
        }
        
        do {
            notes = try context.fetch(request)
        } catch {
            print("Error loading notes \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

        if let destination = segue.destination as? AddNoteVC {
            destination.delegate = self

            if let cell = sender as? UITableViewCell {
                if let index = tableView.indexPath(for: cell)?.row {
                   destination.selectedNote = notes[index]
                }
            }
        }
        
        if let destination = segue.destination as? NoteDetailViewController {
            destination.delegate = self

            if let cell = sender as? UITableViewCell {
                if let index = tableView.indexPath(for: cell)?.row {
                   destination.selectedNote = notes[index]
                }
            }
        }

//        if let destination = segue.destination as? MoveToVC {
//            if let index = tableView.indexPathsForSelectedRows {
//                let rows = index.map {$0.row}
//                destination.selectedNotes = rows.map {notes[$0]}
//            }
//        }
    }

}

//MARK: - search bar delegate methods
extension NotesVC: UISearchBarDelegate {
    
    
    /// search button on keypad functionality
    /// - Parameter searchBar: search bar is passed to this function
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // add predicate
        let predicate = NSPredicate(format: "noteTitle CONTAINS[cd] %@", searchBar.text!)
        loadNotes(predicate: predicate)
    }
    
    
    /// when the text in text bar is changed
    /// - Parameters:
    ///   - searchBar: search bar is passed to this function
    ///   - searchText: the text that is written in the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadNotes()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
