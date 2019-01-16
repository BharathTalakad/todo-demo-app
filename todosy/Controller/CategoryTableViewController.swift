//
//  CategoryTableViewController.swift
//  todosy
//
//  Created by bharath on 2018/12/11.
//  Copyright © 2018 bharath. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryTableViewController: SwipeTableViewController {
    //View controller for the initial screen containing category of todo lists
    //Data stored locally using realm storage
    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.separatorStyle = .none
        
    }
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView : UITableView,numberOfRowsInSection section: Int) -> Int{
        return categoryArray?.count ?? 1
        
    }
    override func tableView(_ tableView : UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categoryArray?[indexPath.row]{
            
            guard let categoryColor = UIColor(hexString: category.color ) else { fatalError() }

            cell.backgroundColor = categoryColor
            cell.textLabel?.text = category.name
            cell.textLabel?.textColor = ContrastColorOf( categoryColor, returnFlat: true)
        }
        else{
             cell.textLabel?.text = "No Categories added yet"
            cell.backgroundColor = UIColor(hexString: UIColor.randomFlat.hexValue() )
        }
        return cell
    }
    
    //MARK: - AddNew Categories

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Enter a new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add ", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name =   textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            self.saveData(category: newCategory)
            self.tableView.reloadData()
            
        }
        alert.addAction(action)
        alert.addTextField { (alerttextField) in
            alerttextField.placeholder = "Create Short Description"
            textField = alerttextField
        }
        
        present(alert, animated: true, completion:  nil)
    }
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Transition to next view when todo category clicked
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Setup data in the next view controller before segue
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathsForSelectedRows?.first {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    
    //MARK: - Data Manipulation Methods
    func saveData(category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving new category \(error)")
        }
    }
    
    func loadData(){
        //Pulls all the objects of type category in realm
        categoryArray = realm.objects(Category.self)

    }
    //    MARK: - Delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemToDelete = self.categoryArray?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(itemToDelete)
//                    self.tableView.reloadData()
                }
            }catch{
                print("Error deleting the particular category : \(error)")
            }
    }
    }
    
}


