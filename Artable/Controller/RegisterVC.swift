//
//  RegisterVC.swift
//  Artable
//
//  Created by Naoki Arakawa on 2019/03/15.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPassTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var passChecking: UIImageView!
    @IBOutlet weak var confirmPassChecking: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //#selectorはobjective-Cの書き方で、＃selectorで関数名を指定している
    //パスワードが入力されたタイミングでイベントが呼び出されて、指定した関数により処理が行われる
    passwordTxt.addTarget(self, action: #selector(textFielDidChange(_:)), for: UIControl.Event.editingChanged)
    confirmPassTxt.addTarget(self, action: #selector(textFielDidChange(_:)), for: UIControl.Event.editingChanged)
    
    }
    
    //文字が入力された時に反応するメソッド
    @objc func textFielDidChange(_ textField: UITextField) {
        
        guard let passTxt = passwordTxt.text else { return }
        
        //confirmPassTxtを入力し始めた時
        if textField == confirmPassTxt {
            
            //マークの赤色が緑色に変わる
            passChecking.isHidden = false
            confirmPassChecking.isHidden = false
            
        } else {
            
            //passTxtが入力されていない場合
            if passTxt.isEmpty {
                
            passChecking.isHidden = true
            confirmPassChecking.isHidden = true
            confirmPassTxt.text = ""
                
            }
        }
      
        //
    //パスワードが一致しているときに、チェックマークが赤色から緑色に変わる
        if passwordTxt.text == confirmPassTxt.text {
            
            passChecking.image = UIImage(named: AppImages.GreenCheck)
            confirmPassChecking.image = UIImage(named: AppImages.GreenCheck)
            
        } else {
            
            passChecking.image = UIImage(named: AppImages.RedCheck)
            confirmPassChecking.image = UIImage(named: AppImages.RedCheck)
            
        }
        
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        
        //guard文で条件が不成立だった場合にelseの後の式が実行される
        //!email.isEmptyは、空っぽではないということを意味している　-> Extensionを作成
        //この,はwhereを意味している
        guard let email = emailTxt.text, email.isNotEmpty ,
            let username = usernameTxt.text, username.isNotEmpty,
            let password = passwordTxt.text, password.isNotEmpty else { return }
        
        //メールアドレスとパスワードがnilではないことを確認できた後にIndicatorを表示する
        activityIndicator.startAnimating()
        
        //firebaseのドキュメントに書かれてる通りにコピペするとエラーが出てしまうため、
        //guard文をかませる
        //インスタンスが１個しか生成されないことを保証したい
        //この１行で、firebase上でemailとpasswordをもとに新しいユーザーを作成する
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            if let error = error {
                debugPrint(error)
                return
                
            }
            
            self.activityIndicator.stopAnimating()
            print("successFully registered new user.")
            
            //guard let user = authResult?.user else { return }
        }
        
    }
    
    
}
