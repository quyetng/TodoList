//
//  AppDelegate.swift
//  TodoList
//
//  Created by QN on 11/29/19.
//  Copyright © 2019 QN. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
      
        
        do {
            _ = try Realm()
           
        } catch {
            print("Error init new realm,\(error)")
        }
        
        
        
        return true
    }

}

    


