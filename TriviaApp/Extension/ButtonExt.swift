//
//  ButtonExt.swift
//  Quizzler
//
//  Created by Gaurav Prakash on 27/03/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
import UIKit
extension UIButton{
    func setCornerRadius() {
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
    }
}
