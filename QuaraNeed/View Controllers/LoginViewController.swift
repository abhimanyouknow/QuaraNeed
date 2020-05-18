//
//  LoginViewController.swift
//  QuaraNeed
//
//  Created by C3PO MBP on 13/05/20.
//  Copyright © 2020 AV. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleButton(loginButton)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func validateTextFields() -> String? {
        
        // Check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all the fields!"
        }
    
        return nil
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        // Validate text fields
            let error = validateTextFields()
            
            if error != nil {
                
                self.errorLabel.text = "Please fill in all the fields"
                self.errorLabel.alpha = 1
            }
            else {
                
                // Create cleaned versions of the text fields
                let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                
                // Signing in the user
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    
                    if error != nil {
                        
                        // Couldn't sign in
                        self.errorLabel.text = "Invalid password or user doesn't exist"
                        self.errorLabel.alpha = 1
                    }
                    else {
                        
                        let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                        
                        self.view.window?.rootViewController = homeViewController
                        self.view.window?.makeKeyAndVisible()
                    }
                }
            }
        }
    
}
