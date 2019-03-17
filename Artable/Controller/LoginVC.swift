//
//  LoginVC.swift
//  Artable
//
//  Created by Naoki Arakawa on 2019/03/15.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTxt.delegate = self
        passwordTxt.delegate = self
        
    }
    
    
    @IBAction func forgotPassClicked(_ sender: Any) {
        
    }
    
    
    @IBAction func loginClicked(_ sender: Any) {
        
    guard let email = emailTxt.text, email.isNotEmpty ,
    let password = passwordTxt.text, password.isNotEmpty else { return }
    
    activityIndicator.startAnimating()
        
        //{ (user, error)に関して、今のところはこういうものだと理解しておけばいいのかな
    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
        
        if let error = error {
            
            
            debugPrint(error.localizedDescription)
            self.handleFireAuthError(error: error)
            self.activityIndicator.stopAnimating()
            return
        }
        
        self.activityIndicator.stopAnimating()
        print("Login was successful")
        
        //戻る
        self.dismiss(animated: true, completion: nil)
    }
}
    
    @IBAction func guestClicked(_ sender: Any) {
        
    }
    
    
}

//エクステンション
extension LoginVC : UITextFieldDelegate {
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        emailTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        emailTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        
        return true
        
    }

    
    
    
}
