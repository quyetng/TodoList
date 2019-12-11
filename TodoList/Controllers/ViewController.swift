//
//  ViewController.swift
//  TodoList
//
//  Created by QN on 11/29/19.
//  Copyright © 2019 QN. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {

    //var itemArray = ["Find Mike", "Buy Eggs", "Clean House"]
    var itemArray = [Item]()
    
    
     var selectedCategory : Category? {
         didSet {
             loadItem()
         }
     }
    
    //let defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("this is a test")
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        )
        
        loadItem()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        

        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        let item = itemArray[indexPath.row]

        //cell.textLabel?.text = itemArray[indexPath.row].title

        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        

        saveItems()
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            

            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.saveItems()
          
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        //let encoder = PropertyListEncoder()
        
        do {
            //let data = try encoder.encode(itemArray)
            //try data.write(to: dataFilePath!)
            try context.save()
        } catch {
            //print("Error encoding item array, \(error)")
            print("Error saving context, \(error)")
        }
                  
    }
    
    func loadItem(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPedicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        //let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
        
        if let additionalPredicate = predicate {
            //request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPedicate, additionalPredicate])
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPedicate, additionalPredicate])
        } else {
            request.predicate = categoryPedicate
        }
        
        do {
            
            itemArray = try context.fetch(request)
            
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()

    }
}


// MARK: - Search bar methods
extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItem(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}
