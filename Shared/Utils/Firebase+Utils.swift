//
//  Firebase+Utils.swift
//  Artable
//
//  Created by Naoki Arakawa on 2019/03/17.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import Firebase

extension Firestore {
    
    // カテゴリを間に挟むことで、timeStampの順番で表示されるようになる
    var categories : Query {
        
        return collection("categories").order(by: "timeStamp", descending: true)
    }
    
    
    func products(category: String) -> Query {
        
        return collection("products").whereField("category", isEqualTo: category).order(by: "timeStamp", descending: true)
    }
}

extension Auth {
    
    //._codeのとろこにエラー番号を入力する
    func handleFireAuthError (error: Error, vc: UIViewController) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .actionSheet)
            
            //OKの後に何かを処理をしたい場合はhandlerに追加する
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            vc.present(alert, animated: true, completion: nil)
            
        }
    }
    
}


extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account. Pick another email!"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "メールアドレスを正しく入力してください。"
        //return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password or email is incorrect."
            
        default:
            return "Sorry, something went wrong."
        }
        
    }
    
    
}
