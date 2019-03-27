//
//  ForgotPasswordVC.swift
//  Artable
//
//  Created by Naoki Arakawa on 2019/03/17.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {
    
    
    @IBOutlet weak var emailTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func cancelClicked(_ sender: Any) {
        
        //前の画面に戻る
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func resetClicked(_ sender: Any) {
        
        guard let email = emailTxt.text , email.isNotEmpty else {
            
            simpleAlert(title: "Error", msg: "Please enter email.")
            return
        }
        
        //パスワードをリセットする
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let  error = error {
                
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                return
                
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    

}
