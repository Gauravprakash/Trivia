//
//  ViewExt.swift
//  Quizzler
//
//  Created by Gaurav Prakash on 30/03/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
import UIKit
extension UIView{
func applyGradientLayer(point: CGFloat){
let gradientLayer = CAGradientLayer()
gradientLayer.frame = self.bounds
let firstColor = UIColor.red
let secondColor = UIColor.green
gradientLayer.colors = [firstColor, secondColor]
gradientLayer.startPoint = CGPoint(x: 0.0, y: 0)
gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
self.layer.addSublayer(gradientLayer)
}
func applyGradientToView(point: CGFloat){
    

}
}


