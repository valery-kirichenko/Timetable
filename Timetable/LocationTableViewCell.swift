//
//  LocationTableViewCell.swift
//  Timetable
//
//  Created by Valery Kirichenko on 08.11.2017.
//  Copyright © 2017 Valery Kirichenko. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var educator: UILabel!
    
    @IBOutlet weak var building: UILabel!
    
    @IBOutlet weak var audience: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
