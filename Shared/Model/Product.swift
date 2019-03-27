//
//  Product.swift
//  Artable
//
//  Created by Naoki Arakawa on 2019/03/18.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import Foundation
import FirebaseFirestore


//製品に保有する変数の情報  
struct Product {
    
    var name : String
    var id : String
    var category : String
    var price : Double
    var productDescription : String
    var imgUrl : String
    var timeStamp : Timestamp
    var stock : Int
    //var favorite : Bool
    //favoriteは製品に保有する情報ではなくて、個々人で保有する情報であるため
    
    init(data: [String: Any]) {
    
    name = data["name"] as? String ?? ""
    id = data["id"] as? String ?? ""
    category = data["category"] as? String ?? ""
    price = data["price"] as? Double ?? 0
    productDescription = data["productDescription"] as? String ?? ""
    imgUrl = data["imgUrl"] as? String ?? ""
    timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
    stock = data["stock"] as? Int ?? 0
    
    
    }
}
    
//    name = data["name"] as? String ?? ""
//    id = data["id"] as? String ?? ""
//    imgUrl = data["imgUrl"] as? String ?? ""
//    isActive = data["isActive"] as? Bool ?? true
//    timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
    

