//
//  ViewController.swift
//  Todoey
//
//  Created by June Nam on 8/6/19.
//  Copyright © 2019 Jun Nam. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var toDoItems : Results<ToDoItem>?
    //var defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("toDoItems.plist")
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //searchBar.delegate = self
        //print(dataFilePath!)
        //loadItems()
    }


    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let curItem = toDoItems?[indexPath.row] {
            cell.textLabel?.text = curItem.title
            cell.accessoryType = curItem.isDone ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)

//        toDoItems[indexPath.row].isDone = !toDoItems[indexPath.row].isDone
//
//        saveItems()
        //tableView.reloadData()
        
        do {
            
            if let curItem = toDoItems?[indexPath.row] {
                try realm.write {
                    
                    //realm.delete(curItem)
                    curItem.isDone = !curItem.isDone
                }
            }
        } catch {
            print("Error saving done status : \(error)")
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //new dialog
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //textfield inside dialog
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create New Item"
        }
        
        //button inside dialog
        let action = UIAlertAction(title: "Add Item", style: .default) { (alertAction) in
 
//            let item = ToDoItem(context: self.context)
//            item.title = textField.text!
//            item.isDone = false
//            item.parentCategory = self.selectedCategory
//            self.itemArray.append(item)
            
            if let curCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = ToDoItem()
                        item.title = textField.text!
                        item.isDone = false
                        
                       curCategory.items.append(item)
                    }
                } catch {
                    print("Error saving new item \(error)")
                }
            }
          
            
            //self.saveItems()
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray") //to persist data
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

    func loadItems() {

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
//         let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        //let request : NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//            tableView.reloadData()
//        } catch {
//            print("Error fetching data from context: \(error)")
//        }


//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//
//            do {
//                itemArray = try decoder.decode([ToDoItem].self, from: data)
//            } catch {
//                print("Error decoding item array: \(error)")
//            }
//        }
//
    }
}

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        toDoItems = toDoItems?.filter(NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)).sorted(byKeyPath: "dateCreated", ascending: true)
       
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text?.count == 0) {
            loadItems()
            searchBar.resignFirstResponder()

            //if on diff thread ->
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
        }
    }
}
