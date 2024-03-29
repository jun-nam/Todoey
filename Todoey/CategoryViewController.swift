//
//  CategoryViewController.swift
//  Todoey
//
//  Created by June Nam on 8/16/19.
//  Copyright © 2019 Jun Nam. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    var categories : Results<Category>?
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
    
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        tableView.separatorStyle = .none
        
        loadCategories()
    }
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"

        if let curCat = categories?[indexPath.row] {
            guard let backColor = UIColor(hexString: curCat.color) else {fatalError()}
            cell.backgroundColor = backColor
            cell.textLabel?.textColor = ContrastColorOf(backColor, returnFlat: true)
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func save(category : Category) {
        do {
            try realm.write() {
                realm.add(category)
            }
        } catch {
            print("Error on saving items \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self).sorted(byKeyPath: "name", ascending: true)
        
//        do {
//            categoryArray = try context.fetch(request)
//            tableView.reloadData()
//
//        } catch {
//            print("Error on loading items \(error)")
//        }
    }
    
    //MARK: - Delete from Swipe
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        do {
            try realm.write {
                if let curCat = categories?[indexPath.row] {
                    realm.delete(curCat)
                }
            }
        } catch {
            print("Error while deleting category : \(error)")
        }
        
        
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        //dialog
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        //text inside dialog
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create New Category"
        }
        
        //button inside : UIAlertAction
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            //self.categoryArray.append(newCategory)
            
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)    
    }
}
