//
//  RonsToDoViewController.swift
//  DevDemoApp
//
//  Created by Ronald Jones on 8/25/25.
//

import UIKit

class RonsToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabView: UITableView!
    var data = [toDoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabView.delegate = self
        self.tabView.dataSource = self
        self.tabView.register(UINib(nibName: "RonsToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "toDo")
        // Do any additional setup after loading the view.
        self.getData()
    }
    
    func getData() {
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
        let todaysDate = Date()
        
        data.append(toDoItem(theText: "Check Table Views", theImage: UIImage(systemName: "magnifyingglass.circle.fill"), date: todaysDate))
        data.append(toDoItem(theText: "Say good job", theImage: UIImage(systemName: "hand.thumbsup.fill"), date: todaysDate))
        data.append(toDoItem(theText: "Assign more work", theImage: UIImage(systemName: "newspaper.fill"), date: todaysDate))
    }
    
    //mandatory
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    //mandatory
    //indexPath = [0,1]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDo", for: indexPath) as! RonsToDoTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
        
        cell.txtLbl.text = data[indexPath.row].theText
        cell.dte.text = dateFormatter.string(from: data[indexPath.row].date ?? Date())
        cell.img.image = data[indexPath.row].theImage
        
        return cell
    }
    //optional
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let DeleteAction = UIContextualAction(style: .destructive, title:  "delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.data.remove(at: indexPath.row)
            self.tabView.reloadData()
    })
        
        let read = UIContextualAction(style: .normal, title:  "message", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.showToast(message: self.data[indexPath.row].theText ?? "No title")
    })
        read.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [DeleteAction, read])
    }
    
    @IBAction func plus(_ sender: Any) {
        let alert = UIAlertController(title: "Add item", message: "What do you want to add?", preferredStyle: .alert)
        
        alert.addTextField { tf in
            tf.placeholder = "to do title"
        }
        
        let add = UIAlertAction(title: "Add", style: .default) { act in
            
           // var newdate = Date() + a day
            
            
            self.data.append(toDoItem(theText: alert.textFields?[0].text ?? "Edit this", theImage: UIImage(), date: Date()))
            self.tabView.reloadData()
        }
        
        let canc = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(add)
        alert.addAction(canc)
        
        self.present(alert, animated: true)
    }
    
}
