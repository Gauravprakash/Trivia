//
//  ViewControllerExt.swift
//  Quizzler
//
//  Created by Gaurav Prakash on 27/03/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController:UIAlertViewDelegate,UIActionSheetDelegate{
    func showActionSheet(title: String, params:[String], onAction: @escaping (String?) -> Swift.Void){
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .actionSheet)
        for button in params{
            let alertAction = UIAlertAction(title:button, style: .default) { (action) in
            onAction(button)
         }
       alertController.addAction(alertAction)
    }
   self.present(alertController, animated: true, completion: nil)
}
}

