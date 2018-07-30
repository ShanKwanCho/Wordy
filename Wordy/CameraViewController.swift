//
//  CameraViewController.swift
//  Wordy
//
//  Created by Nikita Petrenko on 3/17/18.
//  Copyright © 2018 Nikita Petrenko. All rights reserved.
//

import UIKit
import AVKit
import CoreML
import Vision
import ROGoogleTranslate

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // ROGoogleTranslate provides a helper class to simplify the usage of the Google Translate API
    
    @IBOutlet weak var guessCardView: UIView!
    @IBOutlet weak var predictionLabel: UILabel!
    
    // Instances
    let translator = ROGoogleTranslate()
    var pickedLanguage2: String = ""
    var translation: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set API key for Translate API
        translator.apiKey = "AIzaSyB2GAVtA2pnwR2gqbyK5j_fCjPGgIkhG9s"
        
        // Make navbar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        // Set back button color
        _ = UINavigationBar.appearance().tintColor = UIColor(red:0.20, green:0.85, blue:0.74, alpha:1.0)
        let arrow = UIImage(named: "arrow")
        self.navigationController?.navigationBar.backIndicatorImage = arrow
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = arrow
        
        // An object that manages capture activity and coordinates the flow of data from input devices to capture outputs.
        let cameraSession = AVCaptureSession()
        
        // Input device
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            fatalError("Unable to set capture device")
        }
        
        // CameraSession’s input
        guard let captureInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            fatalError("Unable to set capture input")
        }
        
        // Add input and start the session
        cameraSession.addInput(captureInput)
        cameraSession.startRunning()
        
        // Setup the preview size
        let preview = AVCaptureVideoPreviewLayer(session: cameraSession)
        preview.videoGravity = AVLayerVideoGravity.resizeAspectFill

        // Append the layer to the layer’s list of sublayers
        view.layer.addSublayer(preview)
        preview.frame = CGRect(x: 0, y: 0, width: 400, height: 720)
        
        // Create output
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "Dispatch"))
        
        // Add the output
        cameraSession.addOutput(output)
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Gets called each frame
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        // An image buffer that holds pixels in main memory
        guard let CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            fatalError("Unable to create CVPixelBuffer")
        }
        
        // Setting up the model
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Unable to instantiate the model")
        }
        
        // An image analysis request that uses a Core ML model to process images
        let VNRequest = VNCoreMLRequest(model: model) { (req, err) in
            
            let results = req.results as? [VNClassificationObservation]
            let bestPick = results?.first
            //print(bestPick?.identifier)
            
            // Setting up ROGoogleTranslate
            let params = ROGoogleTranslateParams(source: "en", target: self.pickedLanguage2, text: (bestPick?.identifier)!)
            
            self.translator.translate(params: params, callback: { (translatedText) in
                self.translation = translatedText
            })
            
            // Perform the title change on the main thread
            DispatchQueue.main.async {
                if self.pickedLanguage2 != "en" {
                    self.predictionLabel.text = self.translation
                } else {
                    self.predictionLabel.text = bestPick?.identifier
                }
            }
        }
        
        // Perform the request
        try? VNImageRequestHandler(cvPixelBuffer: CVPixelBuffer, options: [:]).perform([VNRequest])
        
        
        // P.s. Sorry for so many comments, but it should help better understand how the app works
        // To learn more, go to https://brando-commando.github.io/Wordy/
        // Made by Nikita, Brandon, and Shan
    }
}
