//
//  SignUpViewController.swift
//  QuaraNeed
//
//  Created by C3PO MBP on 13/05/20.
//  Copyright © 2020 AV. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var fullNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var imagePicker:UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTap)
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
    }
    
    func setUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style the elements 
        Utilities.styleTextField(fullNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(confirmPasswordTextField)
        Utilities.styleButton(signUpButton)
    }
    
    @objc func openImagePicker(_ sender:Any) {
        
        // Open Image Picker
        self.present(imagePicker, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // check the fields for correct data. If the data is correct, this method returns nil; otherwise it returns an error message.
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if fullNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all the fields!"
        }
        
        else if passwordTextField.text != confirmPasswordTextField.text {
            
            return "Passwords don't match!"
        }
        
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // Something is wrong with the fields; show error message.
            showError(error!)
        }
        else {
            
            let fullName = fullNameTextField.text!
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let confirmPassword = confirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard let image = profileImageView.image else { return }
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: confirmPassword) { (result, err) in
                
                // Check for errors
                if err != nil {
                    
                    // There was an error creating user
                    self.showError("Error creating user!")
                }
                else {
                    
                    // User was created successfully
                    
                    // Upload the profile image to Firebase
                    self.uploadProfileImage(image) { url in
                        
                    }
                    
                    // Save the profile data to Firebase Database
                    
                    // Dismiss the view
                    
                    // Store full name
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["Name":fullName, "uid":result!.user.uid]) { (error) in
                        
                        if error != nil {
                            
                            self.showError("Error saving user data!")
                        }
                    }
                    
                    // Transition to the home screen
                    self.transitionToHome()
                }
            }
        }
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping((_ url:URL?)->())) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            
            if error == nil, metaData != nil {
                
                if let url = metaData?.downloadURL() {
                    
                    completion(url)
                } else {
                    
                    completion(nil)
                }
                // Success
            } else {
                // Failed
                completion(nil)
            }
            
        }
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }

}

extension SignUpViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            self.profileImageView.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
