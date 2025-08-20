//
//  SecondViewController.swift
//  DevDemoApp
//
//  Created by Buket on 8/16/25.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var SecondPicLabel : UILabel!
    @IBOutlet weak var SecondImageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SecondPicLabel.text = "This is Evil Mochi! Watch Out!"
        
        SecondImageView.image = UIImage(named: "Evil Mochi")
        SecondImageView.contentMode = .scaleAspectFit

        // Do any additional setup after loading the view.
    }

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
