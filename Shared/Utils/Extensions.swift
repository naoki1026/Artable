//
//  Extensions.swift
//  Artable
//
//  Created by Naoki Arakawa on 2019/03/16.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit
import Firebase

//文字型に対してエクステンションを行なっている
extension String {
    
    var isNotEmpty : Bool {
    
        return !isEmpty
    }
}

//アラートに関するエクステンション
extension UIViewController {
    
      //自分でエラーを追加することができる
      func simpleAlert(title: String, msg: String) {
        
        //エラーの変数を定義
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        //その変数に対して動作をつける
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        //定義した変数を表示
        present(alert, animated: true, completion: nil)
        
    }
}

