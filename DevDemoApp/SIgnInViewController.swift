//
//  SIgnInViewController.swift
//  DevDemoApp
//
//  Created by Ronald Jones on 9/12/25.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SIgnInViewController: UIViewController {

    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    let ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        if emailTxt.text == nil {
            self.showToast(message: "Enter an email")
        }
        Auth.auth().sendPasswordReset(withEmail: self.emailTxt.text!)
    }
    
    @IBAction func signIn(_ sender: Any) {
        if emailTxt.text == nil || passTxt.text == nil {
            self.showToast(message: "Enter an email and password")
        }
        Auth.auth().signIn(withEmail: self.emailTxt.text!, password: self.passTxt.text!) { AuthResult, error in
            if error != nil {
                self.showToast(message: "Error signing in")
                print(error)
            }
            else {
                let todo = RonsToDoViewController()
                self.present(todo, animated: true)
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        if emailTxt.text == nil || passTxt.text == nil {
            self.showToast(message: "Enter an email and password")
        }
        else {
            Auth.auth().createUser(withEmail: emailTxt.text!, password: passTxt.text!) { (authResult, error) in
                if let error = error {
                    self.showToast(message: "Error signing up")
                    print("Error creating user: \(error)")
                } else {
                    self.ref.child("users").child(authResult?.user.uid ?? "unknown").child("uid").setValue(authResult?.user.uid ?? "unknown")
                    self.ref.child("users").child(authResult?.user.uid ?? "unknown").child("email").setValue(self.emailTxt.text!)
                    let todo = RonsToDoViewController()
                    self.present(todo, animated: true)
                }
            }
        }
    }
}
