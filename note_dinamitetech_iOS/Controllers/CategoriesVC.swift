//
//  CategoriesVC.swift
//
//  Created by Ranjana on 2021-05-24.
//

import UIKit
import CoreData

class CategoriesVC: UITableViewController {
    
    // create a categories array to populate the table
    var categories = [Category]()
    
    // create a context to work with core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    @IBAction func addCategoriesClick(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "Enter a Category Name", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let categoryNames = self.categories.map {$0.catName?.lowercased()}
            guard !categoryNames.contains(textField.text?.lowercased()) else {self.showAlert(); return}
            let newCategory = Category(context: self.context)
            newCategory.catName = textField.text!
            self.categories.append(newCategory)
            self.saveCategory()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // change the color of the cancel button action
        cancelAction.setValue(UIColor.orange, forKey: "titleTextColor")
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "folder name"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    /// show alert when the name of the folder is taken
    func showAlert() {
        let alert = UIAlertController(title: "Category Name Taken", message: "Please choose another name", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catgory_cell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].catName
        cell.textLabel?.textColor = .lightGray
        cell.detailTextLabel?.textColor = .lightGray
        cell.detailTextLabel?.text = "\(categories[indexPath.row].notes?.count ?? 0)"
        cell.imageView?.image = UIImage(systemName: "folder")
        cell.selectionStyle = .none
        
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
            
            deleteCategory(category:  categories[indexPath.row])
            saveCategory()
            categories.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    //MARK: - core data interaction methods
    
    /// load categories  from core data
    func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error loading folders \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    /// save Categories into core data
    func saveCategory() {
        do {
            try context.save()
            tableView.reloadData()
        } catch {
            print("Error saving the folder \(error.localizedDescription)")
        }
    }
    
    func deleteCategory(category: Category) {
        context.delete(category)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destination = segue.destination as! NotesVC
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categories[indexPath.row]
        }
    }

}
