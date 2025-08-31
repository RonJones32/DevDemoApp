//
//  ToDoViewController.swift
//  DevDemoApp
//
//  Created by Buket on 8/28/25.
//

// Qxns to Ron:
// 1. When StartVC.xib -> view -> layout is changed to inferred constraits from Autoresizing Mask, ERROR (show)
// - that's why I keep it auto and then change its components to inferred constraints. Is it a problem?
// 2. Had a problem with naming issues. Is there a common practice you follow not to mess up/confuse things?
// 3. Photo picker? Constraints.....:(


import UIKit

class ToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tabView: UITableView!
    
    
    //[dataType]()
    var data = [toDoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabView.delegate = self
        self.tabView.dataSource = self
        self.tabView.register(UINib(nibName: "ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "ToDoCell")
        
        // Pull to refresh
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tabView.refreshControl = refresh
        tabView.alwaysBounceVertical = true  // so pull works even with few rows
        
        self.getData()
        
        // Do any additional setup after loading the view.
    }
    
    func getData() {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-Month"
        let todaysDate = Date()
        
        data.append(toDoItem(text: "Go to gym", date: todaysDate))
        data.append(toDoItem(text: "Learn SwiftUI", date: todaysDate))
    }
    
    //mandatory
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    //mandatory - all the logic resides here
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-Month"
        
        cell.titleLabel.text = data[indexPath.row].text
        cell.dueLabel.text = dateFormatter.string(from: data[indexPath.row].date ?? Date())

        return cell
    }
    
    //optional
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

    // Ron's func to add
    @IBAction func didTapPlus(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add item", message: "What do you want to add?", preferredStyle: .alert)
        
        alert.addTextField { tf in
            tf.placeholder = "to do title"
        }
        
        let add = UIAlertAction(title: "Add", style: .default) { act in
            
           // var newdate = Date() + a day
            
            self.data.append(toDoItem(text: alert.textFields?[0].text ?? "Edit this", date: Date()))
            self.tabView.reloadData()
        }
        
        let canc = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(add)
        alert.addAction(canc)
        
        self.present(alert, animated: true)
    }
    
    // Ron's func to delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
            let DeleteAction = UIContextualAction(style: .destructive, title:  "delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                self.data.remove(at: indexPath.row)
                self.tabView.reloadData()
        })
            return UISwipeActionsConfiguration(actions: [DeleteAction])
        }
    
    // private so this func can only be called inside this file/class
    @objc private func didPullToRefresh() {
        let dummyItem = toDoItem(text: "Pulled at \(Date())", date: Date())
        data.insert(dummyItem, at: 0)   // adds on top
        tabView.reloadData()
        tabView.refreshControl?.endRefreshing()
    }
    
    
    
    
    
    
}

