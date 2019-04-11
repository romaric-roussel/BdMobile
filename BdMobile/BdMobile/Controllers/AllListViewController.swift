//
//  AllListViewController.swift
//  Checklists
//
//  Created by lpiem on 14/03/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit
import CoreData

class AllListViewController: UITableViewController {
    
    /*var lists  = [Checklist]()
    var checklist = [ChecklistItem]()*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //checklist.append(ChecklistItem(text: "mhw"))
        //checklist.append(ChecklistItem(text: "react",checked: true))
        
        //lists.append(Checklist(name: "liste 1"))
        //lists.append(Checklist(name: "liste 2",items: checklist))

        //print(lists[0].name)
        //print(lists[0].items.count)

        
    }
    
    override func awakeFromNib() {
        //loadChecklistItems()
        DataModel.sharedInstance.loadChecklist()
        //print(DataModel.sharedInstance.lists[0].id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .seeList:
            // prepare for segue to Foo
            let delegate = segue.destination as! ChecklistViewController
            let cell = sender as? UITableViewCell
            let indexForSelectedItem = tableView.indexPath(for: cell!)
            //delegate.list = lists[indexForSelectedItem!.row]
            delegate.list = DataModel.sharedInstance.lists[indexForSelectedItem!.row]
            delegate.posList = indexForSelectedItem!.row

            break
            
        case .AddList:
            // prepare for segue to Foo
            let navigation = segue.destination as! UINavigationController
            let controller = navigation.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.listToEdit = nil
            break
        case .EditList:
            let navigation = segue.destination as! UINavigationController
            let controller = navigation.topViewController as! ListDetailViewController
            controller.delegate = self
            let cell = sender as? UITableViewCell
            let indexForSelectedItem = tableView.indexPath(for: cell!)
            //controller.listToEdit = lists[indexForSelectedItem!.row]
            controller.listToEdit = DataModel.sharedInstance.lists[indexForSelectedItem!.row]
            
            break
        
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        // DataModel.sharedInstance.sortChecklists()
        
    }
    
    //datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return lists.count
        return DataModel.sharedInstance.lists.count
    }
    
    //delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkList", for: indexPath)
        //cell.textLabel?.text = lists[indexPath.row].name
        cell.textLabel?.text = DataModel.sharedInstance.lists[indexPath.row].name


        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //lists.remove(at: indexPath.row)
            print("index", indexPath.row)
            DataModel.sharedInstance.deleteList(id: DataModel.sharedInstance.lists[indexPath.row].id!)

            DataModel.sharedInstance.lists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            DataModel.sharedInstance.loadChecklist()
            //saveChecklistItems()
        }
    }
    
    func addDummyTodo(item : String) {
        //lists.append(item)
        //DataModel.sharedInstance.lists.append(item)
        DataModel.sharedInstance.insertNewList(name: item)
        DataModel.sharedInstance.loadChecklist()
        tableView.insertRows(at: [IndexPath(row: DataModel.sharedInstance.lists.count - 1, section: 0)], with:.automatic)
        //saveChecklistItems()
        
    }
    func updateDummyTodo(item : Checklist,index :Int) {
        //lists[index].name = item.name
        DataModel.sharedInstance.lists[index].name = item.name
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        //saveChecklistItems()
    }
    
    
}

extension AllListViewController : ListDetailViewControllerDelegate{
    func ListDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func ListDetailViewController(_ controller: ListDetailViewController, didFinishAddingList item: String) {
        controller.dismiss(animated: true, completion: nil)
        addDummyTodo(item: item)
    }
    
    func ListDetailViewController(_ controller: ListDetailViewController, didFinishEditingList item: Checklist) {
        controller.dismiss(animated: true, completion: nil)
        /*let index = lists.index(where : {
         $0 === item
         })*/
        let index = DataModel.sharedInstance.lists.index(where : {
            $0 === item
        })
        updateDummyTodo(item: item, index: index!)
    }
    
    
    
    
}


extension AllListViewController: SegueHandlerType {
    
    enum SegueIdentifier: String {
        case seeList
        case AddList
        case EditList
        //case editItem
        
    }
}
