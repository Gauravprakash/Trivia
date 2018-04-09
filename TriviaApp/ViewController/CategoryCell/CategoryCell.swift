//
//  categorycell.swift
//  Quizzler
//
//  Created by Gaurav Prakash on 26/03/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var sub_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpData(data:TriviaCategory){
        self.sub_label.text = data.name
    }
}

