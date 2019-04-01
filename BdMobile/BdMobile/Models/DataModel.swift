//
//  DataModel.swift
//  Checklists
//
//  Created by lpiem on 21/03/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit
import CoreData

class DataModel {
    
    static let sharedInstance = DataModel()
    var lists  = [Checklist]()
    var checklist = [ChecklistItem]()
  
    
    private init(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveChecklist),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
        
        let entity = NSEntityDescription.entity(forEntityName: "Checklist", in: managedContext)
        let checklistBase = NSManagedObject(entity: entity!, insertInto: managedContext)
        checklistBase.setValue("lists 4", forKey: "name")
        //checklistBase.setValue("lists 3", forKey: "name")
        let checklistBase2 = Checklist(context: managedContext)
        checklistBase2.name = "list 5"
    }
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var managedContext = {
        appDelegate.persistentContainer.viewContext
    }()
   
    
    
    @objc func saveChecklist() {
        
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save the database : \(error)")
        }
        
        
        /*let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            try encoder.encode(lists).write(to: dataFileUrl)
        } catch {
            print("error")
        }*/
    }
    
    func loadChecklist() {
        
        let fetchRequest: NSFetchRequest<Checklist> = NSFetchRequest<Checklist>(entityName: "Checklist")
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            let results =  fetchedResults as [NSManagedObject]
            lists = results as! [Checklist]
        }catch let error as NSError{print("Could not fetch : \(error)")}
        /*do {
            // Decode data to object
            let jsonDecoder = JSONDecoder()
            let data : Data = try Data(contentsOf: dataFileUrl)
            lists =  try jsonDecoder.decode([Checklist].self, from: data)
        }
        catch {
            print(error)
        }*/
        
    }
    
   /* func sortChecklists() {
        lists.sort {
            $0.name.localizedCompare($1.name) == .orderedAscending
        }
        
        
    }*/
}

