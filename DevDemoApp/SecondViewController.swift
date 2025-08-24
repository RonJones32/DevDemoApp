//
//  SecondViewController.swift
//  DevDemoApp
//
//  Created by Buket on 8/16/25.
//

import UIKit

class SecondViewController: UIViewController {
    //SecondPicLabel creates the UILabel as a variable
    @IBOutlet weak var SecondPicLabel : UILabel!
    //SecondImageView creates the UIImageView as a variable
    @IBOutlet weak var SecondImageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Text to describe picture
        SecondPicLabel.text = "This is Evil Mochi! Watch Out!"
        //Shows an image from an asset called Evil Mochi
        SecondImageView.image = UIImage(named: "Evil Mochi")
        //Scales image to fit within set boundaries
        SecondImageView.contentMode = .scaleAspectFit

        // Do any additional setup after loading the view.
    }
    
    //Function creates a dismissButton that will dismiss the page 
    @IBAction func dismissButton(_ sender : UIButton) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
