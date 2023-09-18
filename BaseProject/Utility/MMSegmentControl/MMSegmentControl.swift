//
//  MMSegmentControl.swift
//  Copyright © 2023 Meet,Monang,Nilomi . All rights reserved.



import UIKit
@IBDesignable
class MMSegmentControl: UISegmentedControl {
    @IBInspectable var colorSelected: UIColor = UIColor.white {
        didSet{
            self.SetupUI()
        }
    }
    @IBInspectable var colorUnSelected: UIColor = UIColor.black {
        didSet{
            self.SetupUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func SetupUI(){
            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: colorUnSelected]
            self.setTitleTextAttributes(titleTextAttributes, for:.normal)
            let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: colorSelected]
            self.setTitleTextAttributes(titleTextAttributes1, for:.selected)
        if #available(iOS 13.0, *)
        {
        }
        else
        {
            self.tintColor = UIColor.init(named: "warm_orange")
            self.backgroundColor = UIColor.init(named: "Gray_Bg")
            self.layer.cornerRadius = 6
            self.removeBorders()
            
        }
    }

}
extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor ?? .clear), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }

    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
