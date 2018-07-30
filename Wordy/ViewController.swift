//
//  ViewController.swift
//  Wordy
//
//  Created by Nikita Petrenko on 3/17/18.
//  Copyright © 2018 Nikita Petrenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var pickedLanguage: String = ""

    
    // Assign ISO 639-1 to pickedLanguage for each language option clicked
    @IBAction func enButton(_ sender: UIButton) {
        pickedLanguage = "en"
    }
    
    @IBAction func esButton(_ sender: UIButton) {
        pickedLanguage = "es"
    }
    
    @IBAction func ruButton(_ sender: UIButton) {
        pickedLanguage = "ru"
    }
    
    @IBAction func buButton(_ sender: UIButton) {
        pickedLanguage = "hi"
    }
    
    @IBAction func grButton(_ sender: UIButton) {
        pickedLanguage = "de"
    }
    
    @IBAction func frButton(_ sender: UIButton) {
        pickedLanguage = "fr"
    }
    
    @IBAction func chButton(_ sender: UIButton) {
        pickedLanguage = "zh"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Hide the navigation bar
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Pass the picked language to CameraViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC: CameraViewController = segue.destination as! CameraViewController
        destinationVC.pickedLanguage2 = pickedLanguage
    }


}

