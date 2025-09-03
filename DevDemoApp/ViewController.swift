//
//  ViewController.swift
//  DevDemoApp
//
//  Created by Ronald Jones on 8/10/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
extension UIViewController {
    func showToast(message : String) {
        let label_width = 300
        _ = label_width/2
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 160, y: self.view.frame.size.height-400, width: 320, height: 35))
        toastLabel.backgroundColor = UIColor.orange.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1.0, delay: 3.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
