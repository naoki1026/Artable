//
//  Extensions.swift
//  Artable
//
//  Created by Naoki Arakawa on 2019/03/16.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit

//文字型に対してエクステンションを行なっている
extension String {
    
    var isNotEmpty : Bool {
        
        return !isEmpty
    }
}

//アラートに関するエクステンション
extension UIViewController {
    
    func handleFireAuthError (error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .actionSheet)
        
        //OKの後に何かを処理をしたい場合はhandlerに追加する
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
