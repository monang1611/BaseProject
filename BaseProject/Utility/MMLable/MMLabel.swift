//
//  MMLable.swift
//  Copyright © 2023 Meet,Monang,Nilomi . All rights reserved.


import Foundation
import UIKit

//        LoraMediumFontOfSize
//        LoraBoldFontOfSize
//        RobotoRegularFontOfSize
//        RobotoMediumFontOfSize
//        RobotoBoldFontOfSize
class MMRobotoMediumLabel:MMLabel{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.font = UIFont.RobotoMediumFontOfSize(size: self.font.pointSize)
    }
}
class MMRobotoBoldLabel:MMLabel{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.font = UIFont.RobotoBoldFontOfSize(size: self.font.pointSize)
    }
}
class MMRobotoRegularLabel:MMLabel{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.font = UIFont.RobotoRegularFontOfSize(size: self.font.pointSize)
    }
}
class MMLoraMediumLabel:MMLabel{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.font = UIFont.LoraMediumFontOfSize(size: self.font.pointSize)
    }
}
class MMLoraBoldLabel:MMLabel{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.font = UIFont.LoraBoldFontOfSize(size: self.font.pointSize)
    }
}
@IBDesignable
class MMLabel: UILabel {
    
    @IBInspectable var border: CGFloat = 0{
        didSet{
            layer.borderWidth = border
        }
    }
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet{
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0{
        didSet{
            layer.shadowRadius = shadowRadius
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var colorShadow: UIColor = UIColor.clear {
        didSet{
            layer.shadowColor = colorShadow.cgColor
        }
    }
    @IBInspectable var maskToBounce: Bool = false {
        didSet{
            
        }
    }
    //MARK: LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // SET ALL LABELS TO VARY size BASED ON TEXT
        self.numberOfLines = 0
    }
    
}


extension NSMutableAttributedString{
    func setColorForText(_ textToFind: String?, with color: UIColor) {

        let range:NSRange?
        if let text = textToFind{
            range = self.mutableString.range(of: text, options: .caseInsensitive)
        }else{
            range = NSMakeRange(0, self.length)
        }
        if range!.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range!)
        }
    }
}
