//
//  BlurEffect.swift
//  iTamin
//
//  Created by Tabber on 2022/10/30.
//

import UIKit
protocol Blurable
{
    var layer: CALayer { get }
    var subviews: [UIView] { get }
    var frame: CGRect { get }
    var superview: UIView? { get }
    func removeFromSuperview()
    
    func blur(blurRadius: CGFloat)
}

extension Blurable
{
    func blur(blurRadius: CGFloat)
    {
        if self.superview == nil
        {
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: frame.width, height: frame.height), false, 1)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
  
        UIGraphicsEndImageContext();
        
        guard let blur = CIFilter(name: "CIGaussianBlur"),
            let this = self as? UIView else
        {
            return
        }
  
        blur.setValue(CIImage(image: image!), forKey: kCIInputImageKey)
        blur.setValue(blurRadius, forKey: kCIInputRadiusKey)
        
        let ciContext  = CIContext(options: nil)
        
        let result = blur.value(forKey: kCIOutputImageKey) as! CIImage?
        
        let boundingRect = CGRect(x:0,
            y: 0,
            width: frame.width,
            height: frame.height)
        
        let cgImage = ciContext.createCGImage(result!, from: boundingRect)

        let filteredImage = UIImage(cgImage: cgImage!)
        
        let blurOverlay = BlurOverlay()
        blurOverlay.frame = boundingRect
        
        blurOverlay.image = filteredImage
        blurOverlay.contentMode = UIView.ContentMode.left
     
        if let superview = superview as? UIStackView,
           let index = (superview as UIStackView).arrangedSubviews.firstIndex(of: this)
        {
            removeFromSuperview()
            superview.insertArrangedSubview(blurOverlay, at: index)
        }
        else
        {
            blurOverlay.frame.origin = frame.origin
            
            UIView.transition(from: this,
                              to: blurOverlay,
                duration: 0.2,
                options: .curveEaseIn,
                completion: nil)
        }
        
        objc_setAssociatedObject(this,
            &BlurableKey.blurable,
            blurOverlay,
            objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

extension UIView: Blurable
{
    func applyGradient(colours: [UIColor]) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.cornerRadius = 5
        self.layer.insertSublayer(gradient, at: 0)
    }
}
class BlurOverlay: UIImageView
{
}

struct BlurableKey
{
    static var blurable = "blurable"
}
