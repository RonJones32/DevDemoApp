//
//  RonsToDoViewController.swift
//  DevDemoApp
//
//  Created by Ronald Jones on 8/25/25.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RonsToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabView: UITableView!
    var data = [toDoItem]()
    var uid = Auth.auth().currentUser?.uid
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabView.delegate = self
        self.tabView.dataSource = self
        self.tabView.register(UINib(nibName: "RonsToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "toDo")
        
        let ref = UIRefreshControl()
        ref.addTarget(self, action: #selector(refr), for: .valueChanged)
        
        tabView.refreshControl = ref
        // Do any additional setup after loading the view.
        self.getData()
    }
    
    @objc func refr() {
        self.data.removeAll()
        self.getData()
        self.tabView.refreshControl?.endRefreshing()
    }
    
    func getData() {
        self.ref.child("users").child(self.uid ?? "unknown2").child("toDoItems").observeSingleEvent(of: .value) { snapshot in
            
            for eachToDo in snapshot.children {
                var newToDo = toDoItem()

                let realToDo = eachToDo as! DataSnapshot
                let toDoDict = realToDo.value as? [String:Any]
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yy"
                
                let theDate = toDoDict?["date"] as? String ?? "01-01-2000"
                
                let url = URL(string: toDoDict?["pic"] as? String ?? "")
                
                let text = toDoDict?["text"] as? String ?? "could not load"
                
                if url == nil || url == URL(string: ""){
                    newToDo = toDoItem(
                        theText: text,
                        theImage: UIImage(),
                        date: dateFormatter.date(from: theDate)
                    )
                    self.data.append(newToDo)
                    self.tabView.reloadData()
                }
                else {
                    print(url)
                    URLSession.shared.dataTask(with: url!) { (data, response, error) in
                        DispatchQueue.main.async {
                            newToDo = toDoItem(
                                theText: text,
                                theImage: UIImage(data: data ?? Data()),
                                date: dateFormatter.date(from: theDate)
                            )
                        }
                    }.resume()
                    
                    print("done")
                    self.data.append(newToDo)
                    self.tabView.reloadData()
                }
                print(newToDo)
                
            }
        }
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
            
        
            let newItem = toDoItem(theText: alert.textFields?[0].text ?? "Edit this", theImage: UIImage(), date: Date())
                        
            self.ref.child("users").child(self.uid ?? "unknown2").child("toDoItems").child(newItem.theText ?? "item1").child("text").setValue(newItem.theText)
            self.ref.child("users").child(self.uid ?? "unknown2").child("toDoItems").child(newItem.theText ?? "item1").child("date").setValue(newItem.date?.description)
            
            self.getData()
            self.tabView.reloadData()
        }
        
        let canc = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(add)
        alert.addAction(canc)
        
        self.present(alert, animated: true)
    }
    
}
