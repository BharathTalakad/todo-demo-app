//
//  ViewController.swift
//  todosy
//
//  Created by bharath on 2018/12/03.
//  Copyright © 2018 bharath. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    //Class connected to View controller that store list of todo items
    var todoItems: Results<Item>?
    let realm = try! Realm()
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colrHex = selectedCategory?.color else{ fatalError("Selected category has no color")}
        title = selectedCategory?.name
        updateNavBar(withHexCode: colrHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        guard let originalColor = UIColor(hexString : "5B8EFB")?.hexValue() else { fatalError()}
        updateNavBar(withHexCode: originalColor)
    }
    //MARK: - Navbar color setup
    
    func updateNavBar(withHexCode colorHexCode: String){
        guard let navBar = navigationController?.navigationBar else { fatalError("navigationController doesn't exist")}
        guard let navBarColor = UIColor(hexString: colorHexCode ) else { fatalError("Invalid color set for category")}
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.barTintColor = navBarColor
        searchBar.barTintColor = navBarColor
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        

    }
    
    
    //MARK Create Table view datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Deque reusable cell to display in tableview
        let cell = super.tableView(tableView , cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let color =  UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(todoItems!.count) ) ){
                 cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
           
            //Ternary operator
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items added"
        }
        
        
        return cell
    }
    
    //MARK TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try self.realm.write{
                    item.done = !item.done
                }
            }catch{
                print("Error updating check mark : \(error)")
            }
            
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK Add button Pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //What happens when users clicks add button

            
            
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.createdTime = Date()
                    currentCategory.items.append(newItem)
                    self.realm.add(newItem)
                    self.tableView.reloadData()
                }
                }catch{
                    print("Error saving item \(error)")
                }
            }
        }
        
        alert.addTextField(configurationHandler: { (alertTextField) in
            alertTextField.placeholder = "Create short Description"
            textField = alertTextField

        })
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadData(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "createdTime", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        //Save data to the local Realm storage
        if let itemToDelete = todoItems?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(itemToDelete)
                }
            }
            catch{
                print("Cant delete TODO item \(error)")
            }
        }
    }
    
    
}
//MARK: -  Search Bar methods to search for specific todo items
extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        todoItems = todoItems?.filter(predicate).sorted(byKeyPath: "createdTime", ascending:  true)
        tableView.reloadData()
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}

