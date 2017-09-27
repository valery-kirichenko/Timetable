//
//  TimetableViewCell.swift
//  Timetable
//
//  Created by Valery Kirichenko on 14.09.17.
//  Copyright © 2017 Valery Kirichenko. All rights reserved.
//

import UIKit

class TimetableViewCell: UITableViewCell {
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var event: UILabel!
    @IBOutlet weak var teacher: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var room: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
