//
//  CategoryCell.swift
//  Artable
//
//  Created by Naoki Arakawa on 2019/03/18.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCell: UICollectionViewCell {
    
    
    @IBOutlet weak var  categoryImg: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        categoryImg.layer.cornerRadius = 5
        
    }
    
    //読み込んでいる間は別の画像を表示してくれる
    func configureCell (category: Category) {
        categoryLbl.text = category.name
        if let url = URL(string: category.imgUrl) {
            let placeholder = UIImage(named: "placeholder")
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            categoryImg.kf.indicatorType = .activity
            //kfはKingfisherのこと
            categoryImg.kf.setImage(with: url, placeholder: placeholder, options: options)
            
        }
    }
}
