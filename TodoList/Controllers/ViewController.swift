//
//  ViewController.swift
//  TodoList
//
//  Created by QN on 11/29/19.
//  Copyright © 2019 QN. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework

class ViewController: SwipeTableViewController {

    //var itemArray = ["Find Mike", "Buy Eggs", "Clean House"]
    //var itemArray = [Item]()
    
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
     var selectedCategory : Category? {
         didSet {
             loadItem()
         }
     }
    
    //let defaults = UserDefaults.standard
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("this is a test")
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        )
        
        tableView.separatorStyle = .none
        
        loadItem()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        

        //let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let color = FlatSkyBlue().darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }

        //cell.textLabel?.text = itemArray[indexPath.row].title

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//
//
//        saveItems()
//
//        tableView.reloadData()
        
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
          
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
            //try context.save()
        } catch {
            //print("Error encoding item array, \(error)")
            print("Error saving context, \(error)")
        }
                  
    }
    
    func loadItem() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()

    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error delete category, \(error)")
            }
            //tableView.reloadData()
            
        }
    }
    
}


 //MARK: - Search bar methods
//extension ViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
//
//        tableView.reloadData()
////        let request: NSFetchRequest<Item> = Item.fetchRequest()
////
////        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
////
////        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
////
////        loadItem(with: request, predicate: predicate)
//
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItem()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
//   }
//
//}
