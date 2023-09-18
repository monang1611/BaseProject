//
//  MMTextView.swift
//  Copyright © 2023 Meet,Monang,Nilomi . All rights reserved.



import UIKit

@IBDesignable
class MMTextView: UITextView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.isEditable = true
        self.tintColor = self.textColor
    }
}
class MMRobotoRegularTextView:MMTextView{
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font = UIFont.RobotoMediumFontOfSize(size: self.font!.pointSize)
    }
}
