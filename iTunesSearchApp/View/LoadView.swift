//
//  loadView.swift
//  iTunes Store Lookup App
//
//  Created by Lion on 30/11/2023.
//

import UIKit

class LoadView: UIView {
    
    private var imageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupActivityIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        
        let theImage = UIImage(named: "loadImage")
        imageView = UIImageView(image: theImage)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    
    }
    
    func startLoading() {
         let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
         rotationAnimation.toValue = NSNumber(value: Double.pi * 2)
         rotationAnimation.duration = 6
        rotationAnimation.speed = 1.5
         rotationAnimation.isCumulative = true
         rotationAnimation.repeatCount = Float.infinity
         imageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
     }
     
     func stopLoading() {
         imageView.layer.removeAnimation(forKey: "rotationAnimation")
     }
}
