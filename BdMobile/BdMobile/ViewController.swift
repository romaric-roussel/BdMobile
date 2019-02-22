//
//  ViewController.swift
//  BdMobile
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
   

    
    var listElement = [ListItem]()
    var alertController:UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //setupConstraints()
        
    }
    
    func  setupConstraints() {
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.heightAnchor.constraint(equalToConstant:44).isActive = true
        navigationBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true


        
    }

    @IBAction func insertRow(_ sender: Any) {
        
        alertController = UIAlertController(title: "New Item", message: "Ajouter un element", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.listElement.append(ListItem(text: self.alertController!.textFields![0].text!))
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alertController!.addAction(cancelAction)
        alertController!.addAction(okAction)
        alertController!.addTextField { (textField) in
            self.alertController!.actions[1].isEnabled = false
            textField.delegate = self
            textField.placeholder = "ecrire la "
        }

        
        present(alertController!,animated: true ,completion: nil)

        
        
    }
    
    func configureCheckmark(for cell: UITableViewCell, withItem item: ListItem){
        
        cell.accessoryType = item.checked ? .checkmark : .none
        
        
    }
    func configureText(for cell: UITableViewCell, withItem item: ListItem){
       
        cell.textLabel?.text = item.text
    }
    
     func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        if let oldString = textField.text {
            let newString = oldString.replacingCharacters(in: Range(range, in: oldString)!,
                                                          with: string)
            
            if((newString.isEmpty)){
                alertController!.actions[1].isEnabled = false
                
            }else {
                alertController!.actions[1].isEnabled = true
            }
            
        }
        return true
    }
    
}

extension ViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")!
        configureText(for: cell, withItem: listElement[indexPath.item])
        configureCheckmark(for: cell, withItem: listElement[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listElement.count
    }
    
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        listElement[indexPath.item].toggleChecked()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listElement.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

