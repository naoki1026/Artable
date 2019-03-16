//
//  RoundedView.swift
//  Artable
//
//  Created by Naoki Arakawa on 2019/03/16.
//  Copyright © 2019 Naoki Arakawa. All rights reserved.
//

import UIKit

class RoundedButton : UIButton {
    
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
    
}


class RoundedShadowView : UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        layer.shadowColor = AppColors.Blue.cgColor
        
        //影をつけることができる
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
    }
    
    
}

class RoundedImageView :  UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
    
}
