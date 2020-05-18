//
//  ViewController.swift
//  QuaraNeed
//
//  Created by C3PO MBP on 11/05/20.
//  Copyright © 2020 AV. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loginEmailButton: UIButton!
    
    @IBOutlet weak var loginGoogleButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        
        // Style the elements
        Utilities.styleButton(loginEmailButton)
        Utilities.styleButton(loginGoogleButton)
        Utilities.styleButton(signUpButton)
    }

}
 
