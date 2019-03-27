//
//  Constants.swift
//  Artable
//
//  Created by Naoki Arakawa on 2019/03/16.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import Foundation
import UIKit


//staticの中でわかりづらいプロパティを定数に変換している
//構造体の名前は大文字から始める
struct Storyboard {
    
    static let LoginStoryboard = "LoginStoryboard"
    static let Main = "Main"

}

struct StoryboardId {
    
    static let LoginVC = "loginVC"
    
}

struct AppImages {
    
    static let GreenCheck = "green_check"
    static let RedCheck = "red_check"
    
}

struct AppColors {
    
    //color literalをクリックすると、カラーパレッドから色を変更することができる
    //UIKitをインポートしてあげる必要がある
    static let Blue = #colorLiteral(red: 0.2274509804, green: 0.2666666667, blue: 0.3607843137, alpha: 1)
    static let Red = #colorLiteral(red: 0.8352941176, green: 0.3921568627, blue: 0.3137254902, alpha: 1)
    static let White = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    
}

struct Identifiers {
    
    static let CategoryCell = "CategoryCell"
    static let ProductCell = "ProductCell"

}

struct Segues {
    
    static let ToProducts = "toProductsVC"
}
