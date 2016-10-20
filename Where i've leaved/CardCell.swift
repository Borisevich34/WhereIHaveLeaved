//
//  CardCell.swift
//  Where i've leaved
//
//  Created by Pavel Borisevich on 19.10.16.
//  Copyright © 2016 Pavel Borisevich. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var landlord: UILabel!
    @IBOutlet weak var monthlyRent: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
