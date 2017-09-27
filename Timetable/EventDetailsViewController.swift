//
//  EventDetailsViewController.swift
//  Timetable
//
//  Created by Valery Kirichenko on 17.09.2017.
//  Copyright © 2017 Valery Kirichenko. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    var event, time, teacher, location: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventLabel.text = event
        timeLabel.text = time
        teacherLabel.text = teacher
        locationLabel.text = location
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
