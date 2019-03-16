//
//  ViewController.swift
//  Artable
//
//  Created by Naoki Arakawa on 2019/03/15.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
        //viewDidAppearはレイアウト処理が終了した後に呼ばれる
        override func viewDidAppear(_ animated: Bool) {
        
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

}

