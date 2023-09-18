//
//  MMImageViewExtension.swift
//  Copyright © 2023 Meet,Monang,Nilomi . All rights reserved.



import Foundation
import UIKit
import SDWebImage

// MARK: UIImageView EXTENTSION
extension UIImageView {
    
    func loadImage(from path: String, placeHolderImage pImage: UIImage?, withContentMode:Bool = true, onCompletion completion:((Bool, UIImage?) -> Swift.Void)? = nil) {
        if withContentMode == true {
            self.contentMode = .scaleAspectFill
            self.clipsToBounds = true
        }
        if let validURL = URL(string: path) {
            self.sd_setImage(with: validURL, placeholderImage: pImage, options: .allowInvalidSSLCertificates, completed: { (image, err, cacheType, url) in
                if let _ = err {
                    if withContentMode == true {
                        self.contentMode = .scaleAspectFill
                    }
                }
                if withContentMode == true {
                    self.contentMode = .scaleAspectFill
                }
                if let completion = completion {
                    self.image = image
                    completion((err == nil), image)
                }
            })
        }else {
            self.image = pImage
        }
    }
    
    func getFrameOfImage(for image: UIImage, inImageViewAspectFit imageView: UIImageView) -> CGRect {
        let imageRatio = (image.size.width / image.size.height)
        let viewRatio = imageView.frame.size.width / imageView.frame.size.height
        if imageRatio < viewRatio {
            let scale = imageView.frame.size.height / image.size.height
            let width = scale * image.size.width
            let topLeftX = (imageView.frame.size.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageView.frame.size.height)
        } else {
            let scale = imageView.frame.size.width / image.size.width
            let height = scale * image.size.height
            let topLeftY = (imageView.frame.size.height - height) * 0.5
            return CGRect(x: 0.0, y: topLeftY, width: imageView.frame.size.width, height: height)
        }
    }
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }
        
        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }
        
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0
        
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}

