//
//  UIFontExtension.swift
//  MMCommon
//
//  Copyright © 2023 Meet,Monang,Nilomi . All rights reserved.



import Foundation
import UIKit

struct Fonts {
    static let LoraMedium = "Lora-Medium"
    static let LoraBold = "Lora-Bold"
    static let RobotoRegular = "Roboto-Regular"
    static let RobotoMedium = "Roboto-Medium"
    static let RobotoBold = "Roboto-Bold"
}
let IS_IPHONE4  = abs(UIScreen.main.bounds.size.height - 480) < 1
let IS_IPHONE5  = abs(UIScreen.main.bounds.size.height - 568) < 1
let IS_IPHONE6  = abs(UIScreen.main.bounds.size.height - 667) < 1
let IS_IPHONE6P = abs(UIScreen.main.bounds.size.height - 736) < 1
let IS_IPHONE_X = UIScreen.main.bounds.height == 812
let IS_IPHONE_XsMax = UIScreen.main.bounds.height == 896 //UIDevice.current.iPhoneX
let IS_IPHONE_XR = UIScreen.main.bounds.height == 896 && UIScreen.main.bounds.width == 414
   
func proportionalFontSize(size:CGFloat) -> CGFloat {
    return (size + (IS_IPHONE6P ? 1 : 0) + (IS_IPHONE6 ? 0 : 0) + (IS_IPHONE5 ? -1 : 0) + (IS_IPHONE4 ? -2 : 0) + ((IS_IPHONE_X || IS_IPHONE_XsMax) ? 2 : 0))
}
// BASE METHOD FOR  FONTS
extension UIFont
{
    class func LoraMediumFontOfSize(size:CGFloat) -> UIFont{
        guard let fontLoad = UIFont(name: Fonts.LoraMedium, size: proportionalFontSize(size: size)) else {
                    fatalError("""
                        Failed to load the "\(Fonts.LoraMedium)" font.
                        Make sure the font file is included in the project and the font name is spelled correctly.
                        """
                    )
            }
         return fontLoad
    }
    class func LoraBoldFontOfSize(size:CGFloat) -> UIFont{
        guard let fontLoad = UIFont(name: Fonts.LoraBold, size: proportionalFontSize(size: size)) else {
                    fatalError("""
                        Failed to load the "\(Fonts.LoraBold)" font.
                        Make sure the font file is included in the project and the font name is spelled correctly.
                        """
                    )
            }
         return fontLoad
    }
    class func RobotoRegularFontOfSize(size:CGFloat) -> UIFont{
        guard let fontLoad = UIFont(name: Fonts.RobotoRegular, size: proportionalFontSize(size: size)) else {
                    fatalError("""
                        Failed to load the "\(Fonts.RobotoRegular)" font.
                        Make sure the font file is included in the project and the font name is spelled correctly.
                        """
                    )
            }
         return fontLoad
    }
    class func RobotoMediumFontOfSize(size:CGFloat) -> UIFont{
        guard let fontLoad = UIFont(name: Fonts.RobotoMedium, size: proportionalFontSize(size: size)) else {
                    fatalError("""
                        Failed to load the "\(Fonts.RobotoMedium)" font.
                        Make sure the font file is included in the project and the font name is spelled correctly.
                        """
                    )
            }
         return fontLoad
    }
    class func RobotoBoldFontOfSize(size:CGFloat) -> UIFont{
        guard let fontLoad = UIFont(name: Fonts.RobotoBold, size: proportionalFontSize(size: size)) else {
                    fatalError("""
                        Failed to load the "\(Fonts.RobotoBold)" font.
                        Make sure the font file is included in the project and the font name is spelled correctly.
                        """
                    )
            }
         return fontLoad
    }
}
