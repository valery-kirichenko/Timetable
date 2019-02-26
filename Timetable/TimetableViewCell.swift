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
        self.startTime.text = nil
        self.endTime.text = nil
        self.subject.text = nil
        self.educator.text = nil
        self.building.text = nil
        self.audience.text = nil
        
        self.startTime.attributedText = nil
        self.endTime.attributedText = nil
        self.subject.attributedText = nil
        self.educator.attributedText = nil
        self.building.attributedText = nil
        self.audience.attributedText = nil
        
        self.startTime.textColor = UIColor.black
        self.endTime.textColor = UIColor.black
        self.subject.textColor = UIColor.black
        self.educator.textColor = UIColor.black
        self.building.textColor = UIColor.black
        self.audience.textColor = UIColor.black
    }

}
