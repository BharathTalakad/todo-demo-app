//
//  AppDelegate.swift
//  todosy
//
//  Created by bharath on 2018/12/03.
//  Copyright © 2018 bharath. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        do{
            _ = try Realm()
            }
        catch{
            print("Error initializing realm \(error)")
        }
        
        return true
    }
}

