//
//  ProductCell.swift
//  Artable
//
//  Created by Naoki Arakawa on 2019/03/18.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCell: UITableViewCell {
    
    
    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //関数の変数に構造体を入れている
    func configureCell(product: Product) {
        productTitle.text = product.name
        //productPrice.text = product.price
        
        if let url = URL(string: product.imgUrl) {
            productImg.kf.setImage(with: url)
            
        }
        
        
    }
    
    
    
    @IBAction func addToCartClicked(_ sender: Any) {
    }
    
    
    @IBAction func favoriteClicked(_ sender: Any) {
    }
    
    
}
