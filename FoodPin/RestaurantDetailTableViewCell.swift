//
//  RestaurantDetailTableViewCell.swift
//  FoodPin
//
//  Created by myron hicks on 2/3/17.
//  Copyright © 2017 myron hicks. All rights reserved.
//

import UIKit

class RestaurantDetailTableViewCell: UITableViewCell {

    @IBOutlet var fieldLabel : UILabel!
    @IBOutlet var valueLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
