//
//  SwipeTableViewController.swift
//  TodoList
//
//  Created by QN on 12/11/19.
//  Copyright © 2019 QN. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
              
              
    
              
        cell.delegate = self
              
        return cell
    }
    
       func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
           guard orientation == .right else { return nil }

           let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
               // handle action by updating model with deletion
            
            self.updateModel(at: indexPath)
//               if let categoryForDeletion = self.categories?[indexPath.row] {
//                   do {
//                       try self.realm.write {
//                           self.realm.delete(categoryForDeletion)
//                       }
//                   } catch {
//                       print("Error delete category, \(error)")
//                   }
//                   //tableView.reloadData()
//
//               }
               
               //print("Item deleted")
           }

           // customize the action appearance
           deleteAction.image = UIImage(named: "Trash Icon")

           return [deleteAction]
       }
       
      func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
          var options = SwipeOptions()
          options.expansionStyle = .destructive
          //options.transitionStyle = .border
          return options
      }

    func updateModel(at indexPath: IndexPath) {
        
    }
}
