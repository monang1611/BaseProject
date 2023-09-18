//
//  MMView.swift
//  Copyright © 2023 Meet,Monang,Nilomi . All rights reserved.


import UIKit
@IBDesignable
class MMBoardView: UIView {
    @IBInspectable  var gradiantSetColor: Bool = false {
        didSet{
            if gradiantSetColor{
                    self.setGradiant()
            }else{
                self.backgroundColor = backgroundColor
            }
        }
    }
    @IBInspectable var colorFirst: UIColor = UIColor.clear{
        didSet{
            if gradiantSetColor{
                self.setGradiant()
            }else{
                self.backgroundColor = colorFirst
            }
        }
    }
    @IBInspectable var colorSecond: UIColor = UIColor.clear {
        didSet{
            if gradiantSetColor{
                self.setGradiant()
            }else{
                self.backgroundColor = colorSecond
            }
        }
    }
    @IBInspectable var BottomLeftCorner: CGFloat = 0.0 {
        didSet{
            self.layoutSubviews()
        }
    }
    
    @IBInspectable var BottomRightCorner: CGFloat = 0.0 {
           didSet{
               self.layoutSubviews()
           }
    }
    
    @IBInspectable var AllCornerRadius: CGFloat = 0.0 {
        didSet{
            self.layer.cornerRadius = AllCornerRadius
            self.layer.masksToBounds = true
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var border: CGFloat = 0{
        didSet{
            layer.borderWidth = border
        }
    }
    @IBInspectable  var RoundedView: Bool = false {
        didSet{
            self.layer.cornerRadius = self.frame.height/2
            self.layer.masksToBounds = true
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        if BottomRightCorner != 0.0 && BottomLeftCorner != 0.0{
            roundCorners(corners: [.bottomRight, .bottomLeft], radius: BottomLeftCorner)
        }else if BottomLeftCorner != 0.0{
            roundCorners(corners: [.bottomLeft], radius: BottomLeftCorner)
        }else if BottomRightCorner != 0.0{
            roundCorners(corners: [.bottomRight], radius: BottomRightCorner)
        }
        if gradiantSetColor == true{
            self.setGradiant()
        }
    }
 
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    func roundCorners2(corners: UIRectCorner, radius1: CGFloat,radius2: CGFloat) {
           let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius1, height: radius2))
           let mask = CAShapeLayer()
           mask.path = path.cgPath
           layer.mask = mask
       }
    func setGradiant(){
        self.applyGradient(colours: [colorFirst,colorSecond], locations: [2,1], radius: 3.0)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override init(frame: CGRect) {
        super.init(frame:frame)
        if gradiantSetColor == true{
            self.setGradiant()
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        if gradiantSetColor == true{
            self.setGradiant()
        }
    }
    func applyGradient(colours: [UIColor], locations: [NSNumber]?, radius: CGFloat = 8) -> Void {
        
        self.layer.sublayers?.filter({ (layerToCheck) -> Bool in
            return layerToCheck.accessibilityLabel == "gradientLabel"
        }).first?.removeFromSuperlayer()
//        
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }

        gradient.accessibilityLabel = "gradientLayer"
        
        
        self.layer.insertSublayer(gradient, at: 0)
        
    }
}
extension UIView{
    func applyCorner(_ radius: CGFloat? = nil)
    {
        self.layoutIfNeeded()
        if let validradius = radius {
            self.layer.cornerRadius = validradius
        } else {
            let newradius = min(self.frame.size.height, self.frame.size.width)
            self.applyCorner(newradius / 2)
        }
        self.layer.masksToBounds = true
    }
    func addShadowWithCorner(shadowColor color:UIColor = UIColor.gray,
                             shadowOffset offset:CGSize = CGSize(width: 1.0, height: 1.0),
                             shadowOpacity opacity : Float = 0.3,
                             shadowRadius radius : CGFloat = 3.0,
                             cornerRadius :CGFloat = 10.0){
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.bounds = self.bounds
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
        
    }
    
}
