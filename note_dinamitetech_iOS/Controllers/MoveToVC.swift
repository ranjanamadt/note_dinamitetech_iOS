//
//  MoveToVC.swift
//  note_dinamitetech_iOS
//
//  Created by Simran Sodhi on 5/28/21.
//

import UIKit
import CoreData

class MoveToVC: UIViewController {

    var categories = [Category]()
    var selectedNotes: [Note]? {
        didSet {
            loadCategories()
            
        }
    }
   
    
    // context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - core data interaction methods
    func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        // predicate
        let CategoryPredicate = NSPredicate(format: "NAME DOESN'T MATCH! %@", selectedNotes?[0].category?.catName ?? "")
        request.predicate = CategoryPredicate
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data \(error.localizedDescription)")
        }
    }
    
    //MARK: - IB Action methods
    
    
    
    
    @IBAction func dismissVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
    }


}

extension MoveToVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = UITableViewCell(style: .default, reuseIdentifier: "")
        cell.textLabel?.text = categories[indexPath.row].catName
        cell.backgroundColor = .darkGray
        cell.textLabel?.textColor = .lightGray
        cell.textLabel?.tintColor = .lightGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Move to \(categories[indexPath.row].catName!)", message: "Are you sure?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Move", style: .default) { (action) in
            for note in self.selectedNotes! {
                note.category = self.categories[indexPath.row]
            }
            // dismiss the vc
            self.performSegue(withIdentifier: "dismissMoveToVC", sender: self)
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        noAction.setValue(UIColor.orange, forKey: "titleTextColor")
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    
}

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


