//
//  ViewController.swift
//  Artable
//
//  Created by Naoki Arakawa on 2019/03/15.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit
import Firebase


class HomeVC: UIViewController {
    
    
    @IBOutlet weak var loginOutBtn: UIBarButtonItem!
    
    

    //1度しか呼び出されない
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ゲストユーザーであるか否かについて確認する
        if Auth.auth().currentUser == nil {
            
            //ゲストユーザーを使用可能にするためのメソッドを呼び出す
            Auth.auth().signInAnonymously { (result, error) in
                
                //エラーが発生した場合
                if let error = error {
                    
                    debugPrint(error)
                }
                
            }
            
        }
        
    }
    
    //viewDidAppearはレイアウト処理が終了した後に呼ばれる
    override func viewDidAppear(_ animated: Bool) {
        
        //状況に応じてボタンの表示名を変更する
        if let _ = Auth.auth().currentUser {
            
            loginOutBtn.title = "Logout"
            
        } else {
            
            loginOutBtn.title = "Login"
            
        }
        
    }
    
    
    //fileprivateは同一ファイル内であればアクセスできるということを表している
    fileprivate func presentLoginController() {
        
        //定数でLoginStoryboradのstoryboradを指定する
        //構造体StoryboardのLoginStoryboardプロパティを指している
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        
        //withIdentifierで指定したstoryboradを指定する
        //構造体StoryboardIdのLoginVCで定義したIdentifierを定義する
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardId.LoginVC)
        
        //これは関数で、一番目の引数で指定したstoryboradを表示する
        //開いている間親ウインドウを操作できなくなる子ウインドウのモーダルとして表示する
        present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func loginOutClicked(_ sender: Any) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        if user.isAnonymous {
            
            presentLoginController()
        
        } else {
              do {
                
                try Auth.auth().signOut()
                Auth.auth().signInAnonymously{ (resutl, error) in
                    if let error = error {
                        
                        debugPrint(error)
                    }
                     self.presentLoginController()
                }
            } catch {
                
                debugPrint(error)
            }
        }
//        //Anonymousではない場合
//        if let user = Auth.auth().currentUser, !user.isAnonymous {
//
//            //we are logged in
//            do {
//
//                //エラーが発生する可能性のある処理
////                try Auth.auth().signOut()
//
//                //ログイン画面を表示する
//                presentLoginController()
//
//            } catch {
//
//                //エラー処理
//                debugPrint(error.localizedDescription)
//
//            }
//
//        } else {
//
//            //ログイン画面を表示する
//            presentLoginController()
//
//        }
    }
}


/*

 
 do {
 throw文によるエラーが発生する可能性のある処理
 } catch {
 エラー処理
 定数errorを通じてエラー値にアクセスすることができる
 }
 
 
 */

