//
//  ZachsToDoViewController.swift
//  DevDemoApp
//
//  Created by Zach Keyser on 8/28/25.
//
import UIKit

class ZachsToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabView: UITableView!
    //Data is the array of ToDoItems
    var data = [toDoItem]()
    //completedItem is the array of number of items completed
    var completedItem: Set<Int> = []
    
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabView.delegate = self
        self.tabView.dataSource = self
        self.tabView.register(UINib(nibName: "ZachsToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "toDo2")
        // Do any additional setup after loading the view.
        self.getData()
        
        //Create refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        //Assign refreshControl to the tableView
        self.tabView.refreshControl = refreshControl
        //Progress bar coloring can be changed here
        self.progressBar.backgroundColor = .gray
        self.progressBar.progressTintColor = .systemBlue
        //Change progress bar to have round corners
        self.progressBar.layer.cornerRadius = 6
        self.progressBar.clipsToBounds = true
        //Show the progress bar
        self.progressBar.setProgress(0.0, animated: false)
        updateProgress()
    }
    
    //Function is called when user pulls down to refresh the list
    @objc func refreshData() {
        //When all data is cleared update completedItem array and progressBar
        if data.count == 0 {
            completedItem.removeAll()
            updateProgress()
        }
        
        //Add or remove to add items back to list
        //self.getData()
        //Reloads data of table
        self.tabView.reloadData()
        //Stop spinner
        self.tabView.refreshControl?.endRefreshing()
    }
    
    //Function is caled to updateProgress in progressBar
    func updateProgress() {
        
        let total = Float(data.count)
        let completed = Float(completedItem.count)
        
        if total > 0 {
            
            let progress = completed / total
            self.progressBar.setProgress(progress, animated: true)
            
            if progress == 1.0 {
                showToast(message: "Tasks Complete!")
            }
        } else {
            self.progressBar.setProgress(0.0, animated: true)
        }
    }
    //Function is called to add three items to the data array
    func getData() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
        let todaysDate = Date()
        
        data.append(toDoItem(theText: "Task #1 Code", theImage: UIImage(systemName: "keyboard.fill"), date: todaysDate))
        data.append(toDoItem(theText: "Task #2 Code", theImage: UIImage(systemName: "cpu.fill"), date: todaysDate))
        data.append(toDoItem(theText: "Task #3 Eat Dinner", theImage: UIImage(systemName: "visionpro.fill"), date: todaysDate))
    }
    
    //mandatory
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    //mandatory
    //indexPath = [0,1]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDo2", for: indexPath) as! ZachsToDoTableViewCell
        
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
    
    //Function creates a slide feature with three options complete, delete and message
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //Displays a delete option to remove item
        let DeleteAction = UIContextualAction(style: .destructive, title:  "delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.data.remove(at: indexPath.row)
            self.tabView.reloadData()
    })
        
        //Displays the title of the selected object
        let read = UIContextualAction(style: .normal, title:  "message", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.showToast(message: self.data[indexPath.row].theText ?? "No title")
    })
        //Displays a complete for item
        //completeActionn removes from data array and adds onto total of completed list
        let completeAction = UIContextualAction(style: .destructive, title:  "Complete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.completedItem.insert(1)
            self.updateProgress()
            self.data.remove(at: indexPath.row)
            self.tabView.reloadData()
    })
        //Change the backgroundColor of the completeAction
        completeAction.backgroundColor = .orange
        
        read.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [DeleteAction, read, completeAction])
    }
    
    //Function is called to add an item into the data array with a title and date
    @IBAction func plus(_ sender: Any) {
        let alert = UIAlertController(title: "Add item", message: "What do you want to add?", preferredStyle: .alert)
        //Title text field
        alert.addTextField { tf in
            tf.placeholder = "to do title"
        }
        //Data text field
        alert.addTextField { tf in
            tf.placeholder = "Due Data (dd-mm-yy), leave blank for today"
        }
        
        let add = UIAlertAction(title: "Add", style: .default) { act in
            //Create both textField options as variables
            let titleText = alert.textFields?[0].text ?? "Edit this"
            let dateText = alert.textFields?[1].text ?? ""
            //Creates a dateFormatter for date
            let dataFormatter = DateFormatter()
            dataFormatter.dateFormat = "dd-MM-yy"
            var date: Date
            //If nothing is entered for date the date is set for Today
            if let parsedDate = dataFormatter.date(from: dateText) {
                date = parsedDate
            } else {
                date = Date()
            }
            //Add both the title and date to the data array
            self.data.append(toDoItem(theText: titleText, theImage: UIImage(), date: date))
            self.tabView.reloadData()
            self.refreshData()
        }
        let canc = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(add)
        alert.addAction(canc)
        
        self.present(alert, animated: true)
    }
    
}
