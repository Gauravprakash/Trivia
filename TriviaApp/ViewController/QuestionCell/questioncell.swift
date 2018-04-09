//
//  questioncell.swift
//  Quizzler
//
//  Created by Gaurav Prakash on 27/03/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit

class questioncell: UITableViewCell {

@IBOutlet weak var question_label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
   
    func setUpData(text:String){
     self.question_label.text = text
    }
    
}
