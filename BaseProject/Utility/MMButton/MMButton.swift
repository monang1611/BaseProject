//
//  MMButton.sMMft
//  Copyright © 2023 Meet,Monang,Nilomi . All rights reserved.


import Foundation
import UIKit

class MMRobotoMediumButton:MMButton{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.titleLabel?.font = UIFont.RobotoMediumFontOfSize(size: (self.titleLabel?.font.pointSize)!)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
class MMRobotoBoldButton:MMButton{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.titleLabel?.font = UIFont.RobotoBoldFontOfSize(size: (self.titleLabel?.font.pointSize)!)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
class MMRobotoRegularButton:MMButton{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.titleLabel?.font = UIFont.RobotoRegularFontOfSize(size: (self.titleLabel?.font.pointSize)!)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
class MMLoraMediumButton:MMButton{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.titleLabel?.font = UIFont.LoraMediumFontOfSize(size: (self.titleLabel?.font.pointSize)!)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
class MMLoraBoldButton:MMButton{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.titleLabel?.font = UIFont.LoraBoldFontOfSize(size: (self.titleLabel?.font.pointSize)!)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

@IBDesignable
class MMButton: UIButton {
    let impact = UIImpactFeedbackGenerator()
    var viewGradientLayer: UIView?
    
    @IBInspectable var borderWidth: CGFloat = 0.0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    
    @IBInspectable  var gradiantSetColor: Bool = false {
        didSet{
            if gradiantSetColor{
                self.layoutSubviews()
            }else{
                self.backgroundColor = backgroundColor
            }
        }
    }
    @IBInspectable var isDisable: Bool = false{
        didSet{
            self.ButtonUpdateForUserInteration(isDisable)
        }
    }
    @IBInspectable var colorFirst: UIColor = UIColor.clear{
        didSet{
//            self.applyGradient(colours: [colorFirst,colorSecond])
            if gradiantSetColor{
                self.layoutSubviews()
            }else{
                self.backgroundColor = colorFirst
            }
        }
    }
    @IBInspectable var colorSecond: UIColor = UIColor.clear {
        
        didSet{
//            self.applyGradient(colours: [colorFirst,colorSecond])
            if gradiantSetColor{
                self.layoutSubviews()
            }else{
                self.backgroundColor = colorSecond
            }
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var isRounded: Bool = false {
        didSet{
            if isRounded == true{
                layer.cornerRadius = self.frame.size.width/2
            }else{
                layer.cornerRadius = cornerRadius
            }
        }
    }
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet{
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.masksToBounds = false
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0{
        didSet{
            layer.shadowRadius = shadowRadius
        }
    }
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        didSet{
            layer.shadowColor = shadowColor.cgColor
        }
    }
    @IBInspectable var maskToBounce: Bool = false {
        didSet{
            
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.applyGradientButton(colours: [colorFirst,colorSecond], cornerRadius: cornerRadius)
    }
    func ButtonUpdateForUserInteration(_ isShow:Bool){
        if isShow ==  false{
            self.alpha = 0.4
            self.isUserInteractionEnabled = false
        }else{
            UIView.animate(withDuration: 0.3) {
                self.alpha = 1.0
                self.isUserInteractionEnabled = true
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
@IBDesignable
class MMBackButton: UIButton {
    
    var onTapHandler : (()->Void)?
    @IBInspectable var backImage: UIImage? = nil{
        didSet{
            self.setImage(backImage, for: .normal)
        }
    }
    
    
    
    override func awakeFromNib() {
        self.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.addTarget(self, action:#selector(MMBackButton.onTapEvent), for: .touchUpInside)
    }
    
    @objc internal func onTapEvent() {
        if let validHandler = self.onTapHandler {
            validHandler()
        }
    }
}
@IBDesignable
class MMCheckButton: UIButton {
    let selection = UISelectionFeedbackGenerator()
    var onCheckUnCheckHandler : (()->Void)?
   
    @IBInspectable var checkImage: UIImage? = nil{
        didSet{
            self.setImage(checkImage, for: .normal)
        }
    }
    @IBInspectable var unCheckImage: UIImage? = nil{
        didSet{
            self.setImage(unCheckImage, for: .normal)
        }
    }
    @IBInspectable var ischecked: Bool = false{
              didSet{
                   if ischecked == true{
                       self.setImage(checkImage, for: .normal)
                   }else if ischecked == false{
                       self.setImage(unCheckImage, for: .normal)
                   }
              }
          }
   
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(MMCheckButton.checkUnCheckEvent), for: .touchUpInside)
    }
    
    @objc internal func checkUnCheckEvent() {
        selection.selectionChanged()
        if let validHandler = self.onCheckUnCheckHandler {
            if ischecked == false{
                self.setImage(checkImage, for: .normal)
                ischecked = true
            }else if ischecked == true{
                self.setImage(unCheckImage, for: .normal)
                ischecked = false
            }
            validHandler()
        }
    }
}
@IBDesignable
class MMRadioButton: UIButton {
    let selection = UISelectionFeedbackGenerator()
    var onCheckUnCheckHandler : (()->Void)?
   
    @IBInspectable var checkImage: UIImage? = nil{
        didSet{
            self.setImage(checkImage, for: .normal)
        }
    }
    @IBInspectable var unCheckImage: UIImage? = nil{
        didSet{
            self.setImage(unCheckImage, for: .normal)
        }
    }
    @IBInspectable var ischecked: Bool = false{
              didSet{
                   if ischecked == true{
                        self.setImage(checkImage, for: .normal)
                   }else if ischecked == false{
                        self.setImage(unCheckImage, for: .normal)
                   }
              }
          }
   
    override func awakeFromNib() {
        self.titleLabel?.font = UIFont.RobotoMediumFontOfSize(size: 14.0)
        self.addTarget(self, action:#selector(MMRadioButton.checkUnCheckEvent), for: .touchUpInside)
    }
    
    @objc internal func checkUnCheckEvent() {
        selection.selectionChanged()
        if let validHandler = self.onCheckUnCheckHandler {
            if ischecked == false{
                self.setImage(checkImage, for: .normal)
                ischecked = true
            }else if ischecked == true{
                self.setImage(unCheckImage, for: .normal)
                ischecked = false
            }
            validHandler()
        }
    }
}


@IBDesignable
class MMCustomButton: MMButton {
    
    @IBInspectable var normalText: String = ""{
        didSet{
            self.updateText()
        }
    }
    
   
    
    @IBInspectable var ColorText: String = ""{
        didSet{
            self.updateText()
        }
    }


    func updateText(){
//        let attributedString = self.setMulitpleAttributeText([normalText,ColorText], colors: [Colors.Black,Colors.ThemePink])
//        self.setAttributedTitle(attributedString, for: .normal)
    }
    override func awakeFromNib() {
//        let attributedString = self.setMulitpleAttributeText([normalText,ColorText], colors: [Colors.Black,Colors.ThemePink])
//        self.setAttributedTitle(attributedString, for: .normal)
    }
//    func setMulitpleAttributeText(_ strings : [String], colors: [UIColor]) -> NSMutableAttributedString {
//        var attributtesSting : [NSMutableAttributedString] = []
//        for i in 0..<strings.count {
//            var attrs = [NSAttributedString.Key.foregroundColor : colors[i],NSAttributedString.Key.font :UIFont.boldLabelFontOfSize(size: 18)]
//            if i == 1{
//                attrs = [NSAttributedString.Key.foregroundColor : colors[i],NSAttributedString.Key.font :UIFont.boldLabelFontOfSize(size: 18)]            }
//            let attributedString = NSMutableAttributedString(string:strings[i], attributes:attrs)
//
//            attributtesSting.append(attributedString)
//        }
//        let testString : NSMutableAttributedString = NSMutableAttributedString(string: "")
//        for i in 0..<attributtesSting.count {
//            testString.append(attributtesSting[i])
//        }
//        return testString
//    }
    
}



class MMLightButton: MMButton {
    
  
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // SET FONT
//        self.titleLabel?.font = UIFont.LightFontOfSize(size: (self.titleLabel?.font.pointSize)!)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }
}

extension UIView {
    func applyGradientButton(colours: [UIColor],cornerRadius:CGFloat) -> Void {
        
        self.subviews.filter({ (layerToCheck) -> Bool in
            return layerToCheck.tag == 1178
        }).first?.removeFromSuperview()
        
        let layer = UIView(frame: self.bounds)
        layer.layer.cornerRadius = 8
        layer.tag = 1178
        layer.isUserInteractionEnabled = false
        
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
          gradient.colors = colours.map { $0.cgColor }
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.00)
        gradient.endPoint = CGPoint(x: 0.75, y: 1.0)
        gradient.cornerRadius = cornerRadius
        layer.layer.addSublayer(gradient)
        
        self.addSubview(layer)
        self.sendSubviewToBack(layer)
        
    }
}
