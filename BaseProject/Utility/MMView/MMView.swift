//
//  MMView.swift
//  Copyright © 2023 Meet,Monang,Nilomi . All rights reserved.


import UIKit
@IBDesignable
class MMView: UIView {
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
    @IBInspectable var TopLeftAndRightCorner: CGFloat = 0.0 {
        didSet{
            self.layoutSubviews()
        }
    }
    
    @IBInspectable var BottomLeftAndRightCorner: CGFloat = 0.0 {
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
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet{
            DispatchQueue.main.async { [self] in
                self.addShadowWithCorner(shadowColor: shadowColor, shadowOffset: shadowOffSet, shadowOpacity: shadowOpacity, shadowRadius: shadowRadius, cornerRadius: AllCornerRadius)
//                self.layer.shadowOpacity = self.shadowOpacity
//                self.layer.masksToBounds = false
            }
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0{
        didSet{
                self.addShadowWithCorner(shadowColor: shadowColor, shadowOffset: shadowOffSet, shadowOpacity: shadowOpacity, shadowRadius: shadowRadius, cornerRadius: AllCornerRadius)
//            self.layer.shadowRadius = self.shadowRadius
//            self.layer.masksToBounds = false
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        didSet{
            DispatchQueue.main.async {  [self] in
                self.addShadowWithCorner(shadowColor: shadowColor, shadowOffset: shadowOffSet, shadowOpacity: shadowOpacity, shadowRadius: shadowRadius, cornerRadius: AllCornerRadius)
//                self.layer.shadowColor = self.shadowColor.cgColor
//                self.layer.masksToBounds = false
            }
        }
    }
    
    
    @IBInspectable var shadowOffSet: CGSize = CGSize.zero {
        didSet{
            DispatchQueue.main.async { [self] in
                self.addShadowWithCorner(shadowColor: shadowColor, shadowOffset: shadowOffSet, shadowOpacity: shadowOpacity, shadowRadius: shadowRadius, cornerRadius: AllCornerRadius)
//                self.layer.shadowOffset = self.shadowOffSet
//                self.layer.masksToBounds = false
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if BottomLeftAndRightCorner != 0{
            roundCorners(corners: [.bottomLeft, .bottomRight], radius: BottomLeftAndRightCorner)
        }else if TopLeftAndRightCorner != 0{
            roundCorners(corners: [.topLeft, .topRight], radius: TopLeftAndRightCorner)
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
