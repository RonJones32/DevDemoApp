//
//  SecondViewController.swift
//  DevDemoApp
//
//  Created by Buket on 8/16/25.
//

import UIKit
import ARKit

class SecondViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var VRView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()

        VRView.delegate = self
        
        VRView.showsStatistics = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = .horizontal // Enable horizontal plane detection

            VRView.session.run(configuration)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        VRView.session.pause()
    }

    @IBAction func vrMode(_ sender: Any) {
        guard let currentFrame = VRView.session.currentFrame else { return }

            // Create the virtual object (e.g., a sphere)
            let sphere = SCNSphere(radius: 0.1)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.green
            sphere.materials = [material]

            let sphereNode = SCNNode(geometry: sphere)

            // Use the camera's transform to position the object in front of the camera
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.5 // -0.5 meters in front of the camera

            let transform = simd_mul(currentFrame.camera.transform, translation)
            sphereNode.simdTransform = transform

            // Add the new node to the scene
            VRView.scene.rootNode.addChildNode(sphereNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

        // Create a plane geometry with the anchor's size
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))

        // Set a semi-transparent material for visualization
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(red: 0.5, green: 0.8, blue: 0.5, alpha: 0.5)
        plane.materials = [material]

        // Create a node to visualize the plane's position and orientation
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0) // Rotate the plane to be horizontal

        // Add the plane visualization to the scene
        node.addChildNode(planeNode)
    }
    
}
