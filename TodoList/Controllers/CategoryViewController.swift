//
//  CategoryViewController.swift
//  TodoList
//
//  Created by QN on 12/8/19.
//  Copyright © 2019 QN. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

//import CoreData

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    //var categoryArray = [Category]()
    
    //var categoryArray = [Category]()
    
    var categories: Results<Category>!
 
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        tableView.separatorStyle = .none
        //tableView.rowHeight = 80
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist")
        }
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }
    // MARK: - TableView DataSource
    // MARK: - Data Manipulation
    // MARK: - Add New Categories
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
//        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Add"
//
//        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].colorCode ?? "3494FA")
//
//        //cell.delegate = self
//
//        cell.backgroundColor = UIColor.randomFlat()
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.colorCode) else {
                fatalError()
            }
            cell.backgroundColor = categoryColor
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //categoryArray[indexPath.row]
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //let newCategory = Category(context: self.context)
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colorCode = UIColor.randomFlat().hexValue()
            
            //self.categories.append(newCategory)
            
            self.saveCategories(category: newCategory)
           
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveCategories(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context, \(error)")
        }
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()

    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error delete item, \(error)")
            }
            //tableView.reloadData()
            
        }
    }
    
    
    


}

