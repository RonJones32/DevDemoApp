//
//  StartViewController.swift
//  DevDemoApp
//
//  Created by Ronald Jones on 8/10/25.
//

import UIKit

class StartViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
        // debugging statement to see if the connection is set
        print("didTapNext fired")
        
        let nextVC = SecondViewController()
        
        // pushes it onto the navigation stack
        //navigationController?.pushViewController(nextVC, animated: true)
        self.present(nextVC, animated: true)
    }

    @IBAction func toDO(_ sender: Any) {
        let todo = RonsToDoViewController()
        self.present(todo, animated: true)
    }
    
}
