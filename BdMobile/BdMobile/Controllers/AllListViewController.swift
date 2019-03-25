//
//  AllListViewController.swift
//  Checklists
//
//  Created by lpiem on 14/03/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class AllListViewController: UITableViewController {
    
    var lists  = [Checklist]()
    var checklist = [ChecklistItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checklist.append(ChecklistItem(text: "mhw"))
        checklist.append(ChecklistItem(text: "react",checked: true))
        lists.append(Checklist(name: "liste 1"))
        lists.append(Checklist(name: "liste 2",items: checklist))

        print(lists[0].name)
        print(lists[0].items.count)

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .seeList:
            // prepare for segue to Foo
            let delegate = segue.destination as! ChecklistViewController
            let cell = sender as? UITableViewCell
            let indexForSelectedItem = tableView.indexPath(for: cell!)
            delegate.list = lists[indexForSelectedItem!.row]
            break
        
        }
    }
    
    //datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count    }
    
    //delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkList", for: indexPath)
        cell.textLabel?.text = lists[indexPath.row].name
        return cell
        
    }
    
    
}

extension AllListViewController: SegueHandlerType {
    
    enum SegueIdentifier: String {
        case seeList
        //case editItem
        
    }
}
