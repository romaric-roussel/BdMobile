//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class ChecklistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var searchBarText = ""
    //var checklistArray = [ChecklistItem]()
    var list: Checklist!
    var posList : Int?
    var filteredArray = [ChecklistItem]()
    /*var documentDirectory: URL {
        get {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
    }
    var dataFileUrl: URL {
        get {
            var path : URL
            let file = "Checklists"
            let ext = "json"
            path = documentDirectory.appendingPathComponent(file).appendingPathExtension(ext)
            return path
        }
    }*/
    //var itemToEdit
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = list.name
        searchBar.delegate = self
        DataModel.sharedInstance.loadChecklistItems(checkList: list)
        
    }
    
    override func awakeFromNib() {
        //DataModel.sharedInstance.loadChecklistItems(checkList: list)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .addItem:
            // prepare for segue to Foo
            let navigation = segue.destination as! UINavigationController
            let controller = navigation.topViewController as! ItemDetailViewController
            controller.delegate = self
            controller.itemToEdit = nil
            controller.checklist = list

            break
        case .editItem:
            let navigation = segue.destination as! UINavigationController
            let controller = navigation.topViewController as! ItemDetailViewController
            controller.delegate = self
            let cell = sender as? ChecklistItemCell
            let indexForSelectedItem = tableView.indexPath(for: cell!)
            if isFiltering() {
                controller.itemToEdit = filteredArray[indexForSelectedItem!.row]
            }else {
                controller.itemToEdit = DataModel.sharedInstance.checklist[indexForSelectedItem!.row]
            }
            
            break
            
        }
        
    }
    
    //datasource
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredArray.count
        }
        //print("dat count = \(DataModel.sharedInstance.checklist.count)")
        return DataModel.sharedInstance.checklist.count    }
    
    //delegate
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        if isFiltering() {
            configureCheckmark(for: cell as! ChecklistItemCell, withItem: filteredArray[indexPath.item])
            configureText(for: cell as! ChecklistItemCell, withItem: filteredArray[indexPath.item])
        } else {
            configureCheckmark(for: cell as! ChecklistItemCell, withItem: DataModel.sharedInstance.checklist[indexPath.item])
            configureText(for: cell as! ChecklistItemCell, withItem: DataModel.sharedInstance.checklist[indexPath.item])
        }
        
        
       /* configureCheckmark(for: cell as! ChecklistItemCell, withItem: checklistArray[indexPath.item])
        configureText(for: cell as! ChecklistItemCell, withItem: checklistArray[indexPath.item])*/
        
        return cell

    }
    
    //deledgte too
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isFiltering(){
            filteredArray[indexPath.item].checked = !filteredArray[indexPath.item].checked
        }
        //print("id filter \(filteredArray[indexPath.item])")
        DataModel.sharedInstance.checklist[indexPath.item].checked = !filteredArray[indexPath.item].checked
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func configureCheckmark(for cell: ChecklistItemCell, withItem item: ChecklistItem){
        
        cell.lbChecked.isHidden = !item.checked
        //saveChecklistItems()

        //cell.accessoryType = item.checked ? .checkmark : .none
        
    }
    func configureText(for cell: ChecklistItemCell, withItem item: ChecklistItem){
            //cell.textLabel?.text = item.text
        cell.lblibelle.text = item.text
        //saveChecklistItems()

    }
    
    
    func addDummyTodo(text : String) {
        //checklistArray.append(item)
        print(list)
        DataModel.sharedInstance.insertNewTodo(text: text, checked: false,checkList: list)
        //DataModel.sharedInstance.checklist[posList].addToChecklist(list)
        DataModel.sharedInstance.loadChecklistItems(checkList: list)
        if(!isFiltering()){
            tableView.insertRows(at: [IndexPath(row: DataModel.sharedInstance.checklist.count - 1, section: 0)], with:.automatic)
        }else{
            filter(searchText: searchBarText)
        }
        //saveChecklistItems()
        
        
    }
    func updateDummyTodo(item : ChecklistItem,index :Int) {
        
         if(!isFiltering()){
            DataModel.sharedInstance.checklist[index].text = item.text
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
         }else {
            filter(searchText: searchBarText)
         }
        /* }else {
            filteredArray[index].text = item.text
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }*/
        
        //saveChecklistItems()
    }
    
    func saveChecklistItems() {
        
       /* let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            try encoder.encode(checklistArray).write(to: dataFileUrl)
        } catch {
            print("error")
        }*/
    }
    

     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print(indexPath)
            
            /*let indexOfItemToRemove = checklistArray.index(where: { (item) -> Bool in
                item.text == filteredArray[indexPath.row].text // test if this is the item you're looking for
            })
            filteredArray.remove(at: indexPath.row)
            checklistArray.remove(at: indexOfItemToRemove!)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            saveChecklistItems()*/
        }
    }
    
    func filter(searchText : String) {
        filteredArray = DataModel.sharedInstance.checklist.filter({( item : ChecklistItem) -> Bool in
            return item.text!.lowercased().contains(searchText.lowercased())})
        
        tableView.reloadData()
    }
    
    
     func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String){
        searchBarText = searchBar.text!
        filter(searchText: searchText)
    }
        
    func isFiltering() -> Bool {
        return (searchBar.text?.count)! > 0 ? true : false
    }
}

extension ChecklistViewController : itemDetailViewControllerDelegate{
   
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: String,_ list: Checklist) {
       controller.dismiss(animated: true, completion: nil)
        addDummyTodo(text: item)
    }
    
    func itemDetailViewController(_ controller:ItemDetailViewController,didFinishEditingItem item:ChecklistItem) {
        controller.dismiss(animated: true, completion: nil)
     
            let index = DataModel.sharedInstance.checklist.index(where : {
                $0 === item
            })
            updateDummyTodo(item: item, index: index!)
        
        
    }
    
    
}

extension ChecklistViewController: SegueHandlerType {
    
    enum SegueIdentifier: String {
        case addItem
        case editItem
        
    }
}


    


