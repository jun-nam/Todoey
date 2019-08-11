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
    //var defaults = UserDefaults.standard
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("toDoItems.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //print(dataFilePath!)
        loadItems()
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
        
        saveToDoItems()
        //tableView.reloadData()
        
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
            
            self.saveToDoItems()
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray") //to persist data
            //self.tableView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveToDoItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
                itemArray = try decoder.decode([ToDoItem].self, from: data)
            } catch {
                print("Error decoding item array: \(error)")
            }
        }
        
    }
}

