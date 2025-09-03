import UIKit
import ARKit
import RealityKit

// --- Main View Controller for Object Scanning ---

class ObjectScannerViewController: UIViewController, ARSessionDelegate {

    // MARK: - IBOutlets
    
    // Connect this to the ARView in your storyboard
    @IBOutlet var arView: ARView!
    
    // Connect this to a button that starts or stops the scan
    @IBOutlet var scanButton: UIButton!
    
    // Connect this to a button that exports the final .arobject file
    @IBOutlet var exportButton: UIButton!

    // MARK: - Properties
    
    private var isScanning = false
    // A property to hold the tracked anchor once it's created by ARKit
    private var scannedObjectAnchor: ARObjectAnchor?

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the session delegate to receive updates
        arView.session.delegate = self
        
        // Initially disable the export button until a scan is complete
        exportButton.isEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Start the AR session when the view appears
        startNewScan()
    }
    
    // MARK: - IBActions

    @IBAction func scanButtonTapped(_ sender: UIButton) {
        if isScanning {
            // Stop the current scan
            stopScan()
            isScanning = false
            sender.setTitle("Start New Scan", for: .normal)
            // Enable export only if a valid object anchor exists
            exportButton.isEnabled = (scannedObjectAnchor != nil)
        } else {
            // Start a new scan
            startNewScan()
            isScanning = true
            sender.setTitle("Stop Scan", for: .normal)
            exportButton.isEnabled = false // Disable export while scanning
        }
    }

    @IBAction func exportButtonTapped(_ sender: UIButton) {
        // Use the stored scannedObjectAnchor instead of `trackedAnchors`
        guard let referenceObject = scannedObjectAnchor?.referenceObject else {
            print("Error: No reference object found to export.")
            showAlert(title: "Export Failed", message: "Could not find a scanned object to export.")
            return
        }
        
        // Use async/await to handle the export in the background
        Task {
            await export(referenceObject: referenceObject)
        }
    }

    // MARK: - AR Scanning Logic

    private func startNewScan() {
        // Ensure the device supports object scanning
        guard ARObjectScanningConfiguration.isSupported else {
            showAlert(title: "Unsupported Device", message: "This device does not support object scanning.")
            scanButton.isEnabled = false
            return
        }
        
        // Clear the previous anchor to start fresh
        self.scannedObjectAnchor = nil
        
        // Create a new object scanning configuration
        let configuration = ARObjectScanningConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the session with the new configuration and reset options
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        print("New scan started.")
    }

    private func stopScan() {
        // Simply pause the session. The data remains available until a new scan is started.
        arView.session.pause()
        print("Scan stopped.")
    }
    
    // MARK: - ARSessionDelegate

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        // Find the first ARObjectAnchor and store it
        guard scannedObjectAnchor == nil,
              let newAnchor = anchors.compactMap({ $0 as? ARObjectAnchor }).first else {
            return
        }
        scannedObjectAnchor = newAnchor
        print("Scanned object anchor added and stored.")
    }

    // MARK: - Export Logic

    private func export(referenceObject: ARReferenceObject) async {
        do {
            // Get the app's document directory URL
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            // Create a unique name for the file
            let fileName = "ScannedObject-\(Date().timeIntervalSince1970).arobject"
            let fileURL = documentsURL.appendingPathComponent(fileName)
            
            // Capture the snapshot asynchronously
            arView.snapshot(saveToHDR: false) { [weak self] (image) in
                guard let self = self, let previewImage = image else {
                    print("Error: Could not capture snapshot.")
                    self?.showAlert(title: "Export Failed", message: "Could not capture a preview image.")
                    return
                }
                
                // Use a Task block to call the export method with the captured image
                Task {
                    do {
                        try referenceObject.export(to: fileURL, previewImage: previewImage)
                        
                        // Present the share sheet on the main thread
                        await MainActor.run {
                            self.presentShareSheet(for: fileURL)
                        }
                        
                    } catch {
                        print("Error exporting reference object: \(error)")
                        await MainActor.run {
                            self.showAlert(title: "Export Failed", message: "An error occurred while exporting the object: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - UI Helpers

    private func presentShareSheet(for url: URL) {
        // UIActivityViewController is the standard iOS "Share" sheet
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        // For iPad compatibility
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.exportButton
            popoverController.sourceRect = self.exportButton.bounds
        }
        
        self.present(activityViewController, animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
