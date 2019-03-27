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
        
        emailTxt.delegate = self
        usernameTxt.delegate = self
        passwordTxt.delegate = self
        confirmPassTxt.delegate = self
        
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
            let password = passwordTxt.text, password.isNotEmpty else {
                
                simpleAlert(title: "Error", msg: "Please fill out all fields.")
                return
        }
        //, confirmPass == password <- この部分はなおかつと捉えればいいのかな
        guard let confirmPass = confirmPassTxt.text , confirmPass == password else {
            
            simpleAlert(title: "Error", msg: "Password do not match.")
            return
        }
        
        //メールアドレスとパスワードがnilではないことを確認できた後にIndicatorを表示する
        activityIndicator.startAnimating()
        
        //匿名かどうかに関わらず、現在ログインしているユーザーの情報を取得してくる
        //そのユーザーの情報を新しいプロバイダとリンクさせることができる
        guard let authUser = Auth.auth().currentUser else {
            
            return
        }
        
        //credentialは信用情報、資格、資質
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        //let facebookCredential = FacebookAuthProvider.credential(withAccessToken: String)
        //linkWithCredential:completion: の呼び出しが成功したら、
        //ユーザーの新しいアカウントが匿名アカウントの Firebase データにアクセスできるようになります。
        authUser.linkAndRetrieveData(with: credential) { (resukt, error) in
            
            if let error = error {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                return
            }
            
            //インディケーターを止める
            self.activityIndicator.stopAnimating()
            
            print("successFully registered new user.")
            
            //戻る
            self.dismiss(animated: true, completion: nil)
            
            //guard let user = authResult?.user else { return }
        }
    }
        
        
//        //firebaseのドキュメントに書かれてる通りにコピペするとエラーが出てしまうため、
//        //guard文をかませる
//        //インスタンスが１個しか生成されないことを保証したい
//        //この１行で、firebase上でemailとpasswordをもとに新しいユーザーを作成する
//        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
//
//            if let error = error {
//                debugPrint(error)
//                return
//
//            }
//
//            self.activityIndicator.stopAnimating()
//
//            print("successFully registered new user.")
//
//            self.dismiss(animated: true, completion: nil)
//
//            //guard let user = authResult?.user else { return }
//        }
//
//    }
    
}

//エクステンション
extension RegisterVC {
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        emailTxt.resignFirstResponder()
        usernameTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        confirmPassTxt.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        emailTxt.resignFirstResponder()
        usernameTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        confirmPassTxt.resignFirstResponder()
        
        return true
        
 }

}
