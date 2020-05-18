//
//  HomeViewController.swift
//  QuaraNeed
//
//  Created by C3PO MBP on 13/05/20.
//  Copyright © 2020 AV. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        Utilities.styleButton(signOutButton)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signOutTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "signOut", sender: nil)
    }
}
