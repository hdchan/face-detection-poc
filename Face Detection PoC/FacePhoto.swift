//
//  FacePhoto.swift
//  Camera PoC
//
//  Created by Henry Chan on 1/12/16.
//  Copyright © 2016 Henry Chan. All rights reserved.
//

//import Foundation
import UIKit

class FacePhoto: UIImageView {
    
    var faceFeatures:[CIFeature]?
    
    override var image: UIImage? {
        get {
            return super.image
        }
        set {
            super.image = newValue
            detectFace()
        }
    }
    
    private var imageFrameSubView = UIView()
    private var scale: CGFloat = 1
    
    private func getImageFrame() -> CGRect {
        
        if self.image?.size.width > self.image?.size.height { // landscape
            
            scale = self.bounds.width / (self.image?.size.width)!
            
            let imageHeight = (self.image?.size.height)! * scale
            
            let imageFrame = CGRect(x: 0, y: (self.frame.height - imageHeight) / 2, width: self.frame.width, height: imageHeight)
            
            return imageFrame
            
        } else if self.image?.size.width < self.image?.size.height { // portrait
            
            scale = self.bounds.height / (self.image?.size.height)!
            
            let imageWidth = (self.image?.size.width)! * scale
            
            let imageFrame = CGRect(x: (self.frame.width - imageWidth) / 2, y: 0, width: imageWidth, height: self.frame.height)
            
            return imageFrame
            
        } else { // square
            scale = 1
            return self.frame
        }
        
    }
    
    private func detectFace() {
        
        let context = CIContext(options: nil)
        let opts = [CIDetectorAccuracy:CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: opts)
        
        let image = CIImage(CGImage:self.image!.CGImage!)
        
        let features = detector.featuresInImage(image)
        print(features)
        
        faceFeatures = features
        
        imageFrameSubView.subviews.forEach({ $0.removeFromSuperview() })
        
        if features.count > 0 {
            
            imageFrameSubView = UIView(frame: getImageFrame())
            
            for faceFeature in features {
                
                let scaledFaceFrame = CGRect(x: faceFeature.bounds.origin.x * scale, y: ((self.image?.size.height)! - faceFeature.bounds.origin.y - faceFeature.bounds.size.height) * scale, width: faceFeature.bounds.width * scale, height: faceFeature.bounds.height * scale)
                let faceView = UIView(frame: scaledFaceFrame)
                
                faceView.layer.borderWidth = 1
                faceView.layer.borderColor = UIColor.redColor().CGColor
                
                imageFrameSubView.addSubview(faceView)
            }
            
            
            self.addSubview(imageFrameSubView)
            
        }
        
    }
    
    func getFaceImage(faceFeature: CIFaceFeature) -> UIImage {
        
        let faceFrame = CGRect(x: faceFeature.bounds.origin.x, y: ((self.image?.size.height)! - faceFeature.bounds.origin.y - faceFeature.bounds.size.height), width: faceFeature.bounds.width, height: faceFeature.bounds.height)
        
        let imageRef = CGImageCreateWithImageInRect(self.image!.CGImage, faceFrame)
        
        return UIImage(CGImage: imageRef!)
        
    }
    
}