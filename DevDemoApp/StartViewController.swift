//
//  StartViewController.swift
//  DevDemoApp
//
//  Created by Ronald Jones on 8/10/25.
//

import UIKit

class StartViewController: UIViewController {

    //picLabel creates the UILabel as a variable
    @IBOutlet weak var picLabel : UILabel!
    //imageView creates the UIImageView as a variable
    @IBOutlet weak var imageView : UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Text to describe image
        picLabel.text = "This is Mochi!"
        //Shows image from an asset called "Mochi"
        imageView.image = UIImage(named: "Mochi")
        //Scales image to fit within set boundaries
        imageView.contentMode = .scaleAspectFit
     
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
        // debugging statement to see if the connection is set
        print("didTapNext fired")
        
       let nextVC = SecondViewController()
        
        //This is a controller that opens a new window that can be dismissed
        //navigationController?.pushViewController(nextVC, animated: true)
        
        //This is the updated controller opening a new window that doens't dismiss
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
       
    }

}
