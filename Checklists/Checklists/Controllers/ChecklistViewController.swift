//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var checklistArray = [ChecklistItem]()
    //var itemToEdit
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        checklistArray.append(ChecklistItem(text: "Tennis", checked: true))
        checklistArray.append(ChecklistItem(text: "React", checked: false))
        checklistArray.append(ChecklistItem(text: "Swift"))
        checklistArray.append(ChecklistItem(text: "MHW"))
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .addItem:
            // prepare for segue to Foo
            let navigation = segue.destination as! UINavigationController
            let controller = navigation.topViewController as! AddItemViewController
            controller.delegate = self
            break
        case .editItem:
            break
            
        }
        
    }
    
    //datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklistArray.count    }
    
    //delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
    
        configureCheckmark(for: cell as! ChecklistItemCell, withItem: checklistArray[indexPath.item])
        configureText(for: cell as! ChecklistItemCell, withItem: checklistArray[indexPath.item])
        
        return cell

    }
    
    //deledgte too
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        checklistArray[indexPath.item].toggleChecked()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func configureCheckmark(for cell: ChecklistItemCell, withItem item: ChecklistItem){
        
        cell.lbChecked.isHidden = !item.checked
        //cell.accessoryType = item.checked ? .checkmark : .none
        
    }
    func configureText(for cell: ChecklistItemCell, withItem item: ChecklistItem){
            //cell.textLabel?.text = item.text
        cell.lblibelle.text = item.text
    }
    
    
    func addDummyTodo(item : ChecklistItem) {
        checklistArray.append(item)
        tableView.insertRows(at: [IndexPath(row: checklistArray.count - 1, section: 0)], with:.automatic)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            checklistArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ChecklistViewController : AddItemViewControllerDelegate{
    
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishAddingItem item: ChecklistItem) {
       controller.dismiss(animated: true, completion: nil)
        addDummyTodo(item: item)
        //print(item.text)
    }
    
    
    
}

extension ChecklistViewController: SegueHandlerType {
    
    enum SegueIdentifier: String {
        case addItem
        case editItem
        
    }
}
    


