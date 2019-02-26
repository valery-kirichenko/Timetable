//
//  GroupsListTableViewCell.swift
//  Timetable
//
//  Created by Valery Kirichenko on 01.11.2017.
//  Copyright © 2017 Valery Kirichenko. All rights reserved.
//

import UIKit

class GroupsListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var groupName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
