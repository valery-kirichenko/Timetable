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
    @IBOutlet weak var subject: UILabel!
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
    
    override func prepareForReuse() {
        self.contentView.layer.opacity = 1.0
        self.startTime.backgroundColor = nil
        self.endTime.backgroundColor = nil
        self.subject.backgroundColor = nil
        self.educator.backgroundColor = nil
        self.building.backgroundColor = nil
        self.audience.backgroundColor = nil
        
        self.subject.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    }

}
