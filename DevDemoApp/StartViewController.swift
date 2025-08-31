//
//  StartViewController.swift
//  DevDemoApp
//
//  Created by Ronald Jones on 8/10/25.
//

import UIKit
import PhotosUI

class StartViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
        // debugging statement to see if the connection is set
        print("didTapNext fired")
        
        let nextVC = SecondViewController()
    
        // dismissable
        self.present(nextVC, animated: true)
        
        //not dismissable
        // self.modalPresentationStyle = .fullScreen
        
        // pushes it onto the navigation stack -- Though we don't use this practise
        //navigationController?.pushViewController(nextVC, animated: true)
    }


    @IBAction func didTapToDo(_ sender: UIButton) {
        let todo = ToDoViewController()
        self.present(todo, animated: true)
    }
    
    @IBAction func didTapChoosePhoto(_ sender: Any) {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1   // user can only pick one picture
        config.filter = .images     // only photos, no videos

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}

// ChatGPT 5's func

// This extension makes StartViewController able to handle results from the photo picker
extension StartViewController: PHPickerViewControllerDelegate {
    // This method is automatically called when the user picks an image (or cancels)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        // Get the first selected item (if any) and make sure it's an image
        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }

        // Load the image asynchronously (in the background)
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            // When the image is ready, check it's a UIImage
            if let image = object as? UIImage {
                // Switch to the main thread to update the UI safely
                DispatchQueue.main.async {
                    // Display the selected image in imgView on screen
                    self?.imgView.image = image
                }
            }
        }
    }
}
