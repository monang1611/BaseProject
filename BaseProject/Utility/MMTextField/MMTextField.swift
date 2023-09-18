//
//  MMTextField.swift
//  Copyright © 2023 Meet,Monang,Nilomi . All rights reserved.


import UIKit

/**
Represents a MMTextField responder UITextField.
When the instance becomes first responder, and then the user taps the action button (e.g. return keyboard key) 
then one of the following happens:
1. If nextResponderField is not set, keyboard dismissed.
2. If nextResponderField is a UIButton and disabled, then keyboard dismissed.
3. If nextResponderField is a UIButton and enabled, then the UIButton fires touch up inside event (simulating a tap).
4. If nextResponderField is another implementation of UIResponder (e.g. other text field), then it becomes the first responder (e.g. receives keyboard input).

@author Monang Champaneri
@version 1.0
*/

typealias TextFieldDelegateEventBlock = (UITextField) -> Void
//        LoraMediumFontOfSize
//        LoraBoldFontOfSize
//        RobotoRegularFontOfSize
//        RobotoMediumFontOfSize
//        RobotoBoldFontOfSize

class MMRobotoMediumTextField:MMTextField{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.font = UIFont.RobotoMediumFontOfSize(size: self.font!.pointSize)
    }
}
class MMRobotoBoldTextField:MMTextField{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.font = UIFont.RobotoBoldFontOfSize(size: self.font!.pointSize)
    }
}
class MMRobotoRegularTextField:MMTextField{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.font = UIFont.RobotoRegularFontOfSize(size: self.font!.pointSize)
    }
}
class MMLoraMediumTextField:MMTextField{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.font = UIFont.LoraMediumFontOfSize(size: self.font!.pointSize)
    }
}
class MMLoraBoldTextField:MMTextField{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.font = UIFont.LoraBoldFontOfSize(size: self.font!.pointSize)
    }
}
@IBDesignable
class MMTextField: UITextField  {
    
    var shouldbeginEditingHandler: TextFieldDelegateEventBlock?
    var endEditingHandler: TextFieldDelegateEventBlock?
    var shouldReturnEventHandler: TextFieldDelegateEventBlock?
    var textDidChangeHandler: TextFieldDelegateEventBlock?
    /// Represents the next field. It can be any responder.
    /// If it is UIButton and enabled then the button will be tapped.
    /// If it is UIButton and disabled then the keyboard will be dismissed.
    /// If it is another implementation, it becomes first responder.
    @IBOutlet open weak var MMTextField: UIResponder?
//    Padding Variable DefineGlobal
    var TopSpeace : CGFloat = 0.0
    enum FiledType:Int {
        case Name = 1
        case Email = 2
        case Password = 3
        case Other = 0
    }    /// IBInspectable of TextFiled
    var TextType:FiledType = .Other
    @IBInspectable var border: CGFloat = 0{
        didSet{
            layer.borderWidth = border
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var errorBorderColor: UIColor = UIColor.clear{
        didSet{
            layer.borderColor = errorBorderColor.cgColor
        }
    }
    @IBInspectable var borderClickColor: UIColor = UIColor.clear{
        didSet{
            layer.borderColor = borderClickColor.cgColor
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
    
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        didSet{
            layer.shadowColor = shadowColor.cgColor
        }
    }
    @IBInspectable var shadowClickColor: UIColor = UIColor.clear {
        didSet{
            layer.shadowColor = shadowClickColor.cgColor
        }
    }
    
    @IBInspectable var OnClickColor: UIColor = UIColor.clear{
        didSet{
            layer.backgroundColor = OnClickColor.cgColor
        }
    }
    
    @IBInspectable var shadowOffSet: CGSize = CGSize.zero {
        didSet{
            layer.shadowOffset = shadowOffSet
        }
    }
  
    @IBInspectable var maskToBounce: Bool = false {
        didSet{
            
        }
    }
    @IBInspectable var rightImage : UIImage? {
        didSet {
            updateRightView()
        }
    }
    
    @IBInspectable var rightPadding : CGFloat = 0 {
        didSet {
            updateRightView()
        }
    }
    
    @IBInspectable var leftImage : UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding : CGFloat = 0 {
        didSet {
            updateView()
        }
    }
    /**
    Creates a new view with the passed coder.

    :param: aDecoder The a decoder

    :returns: the created new view.
    */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    /**
    Creates a new view with the passed frame.

    :param: frame The frame

    :returns: the created new view.
    */
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    /**
    Sets up the view.
    */
    private func setUp() {
        self.tintColor = self.textColor
        self.layer.cornerRadius = 0.0
        self.clipsToBounds = true
        self.delegate = self
        addTarget(self, action: #selector(actionKeyboardButtonTapped(sender:)), for: .editingDidEndOnExit)
    }
    func leftView(text:String){
        self.leftViewMode = .always
        
        let lable:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: self.frame.size.height))
        lable.text = text
        self.leftView?.autoresizesSubviews = true
        self.leftView?.addSubview(lable)
    }
    func updateView() {
        if let image = leftImage {
            leftViewMode = .always
            
            // assigning image
            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 20, height: 20))
            imageView.image = image
            
            var width = leftPadding + 20
            
            if borderStyle == UITextField.BorderStyle.none || borderStyle == UITextField.BorderStyle.line {
                width += 5
            }
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20)) // has 5 point higher in width in imageView
            view.addSubview(imageView)
            
            
            leftView = view
            
        } else {
            // image is nill
            leftViewMode = .never
        }
    }
    func updateRightView() {
        if let image = rightImage {
            rightViewMode = .always
            
            // assigning image
            let imageView = UIImageView(frame: CGRect(x: rightPadding, y: 0, width: 20, height: 20))
            imageView.image = image
            
            var width = rightPadding - 20
            
            if borderStyle == UITextField.BorderStyle.none || borderStyle == UITextField.BorderStyle.line {
                width -= 5
            }
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20)) // has 5 point higher in width in imageView
            view.addSubview(imageView)
            
            
            rightView = view
            
        } else {
            // image is nill
            rightViewMode = .never
        }
    }
   
    /**
    Action keyboard button tapped.

    :param: sender The sender of the action parameter.
    */
    @objc private func actionKeyboardButtonTapped(sender: UITextField) {
        switch MMTextField {
        case let button as UIButton where button.isEnabled:
            button.sendActions(for: .touchUpInside)
        case .some(let responder):
            responder.becomeFirstResponder()
        default:
            resignFirstResponder()
        }
    }
    func ErrorShow(){
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = border
        self.layer.borderColor = errorBorderColor.cgColor
        self.backgroundColor = backgroundColor
    }
    func ErrorHide(){
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = border
        self.layer.borderColor = borderColor.cgColor
        self.backgroundColor = backgroundColor
    }
    
    let padding = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
   
}
extension MMTextField : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        ErrorHide()
        if let validHandler = self.shouldbeginEditingHandler {
            validHandler(self)
        }
        return true
    }
 
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch TextType {
        case .Name:
            if textField.text?.isName == false{
                ErrorShow()
            }
        case .Email:
            if textField.text?.isEmail == false{
                ErrorShow()
            }
        case .Password:
            if textField.text?.isValidPassword == false{
                ErrorShow()
            }
        case .Other:
            if textField.text?.setMinMaxCount(8, max: 20) == false{
                ErrorShow()
            }
//        default:
//            ErrorHide()
        }
        if let validHandler = self.endEditingHandler {
            validHandler(self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let validHandler = self.shouldReturnEventHandler {
            validHandler(self)
        }
        return true
    }
}

