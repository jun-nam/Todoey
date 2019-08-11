//
//  ViewController.swift
//  Todoey
//
//  Created by June Nam on 8/6/19.
//  Copyright © 2019 Jun Nam. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray : [ToDoItem] = []// = [item1, item2, item3]
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        for i in 1...30 {
            itemArray.append(ToDoItem(description: "item\(i)"))
        }
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [ToDoItem] {
            print(items)
            itemArray = items
        }
    }


    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let curItem = itemArray[indexPath.row]
        cell.textLabel?.text = curItem.title
        cell.accessoryType = curItem.isDone ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
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
 
            self.itemArray.append(ToDoItem(description: textField.text!))
            
            self.defaults.set(self.itemArray, forKey: "ToDoListArray") //to persist data
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

