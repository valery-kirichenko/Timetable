//
//  EventDetailsViewController.swift
//  Timetable
//
//  Created by Valery Kirichenko on 17.09.2017.
//  Copyright © 2017 Valery Kirichenko. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    var subject: SubjectInstance!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone(identifier: "MSK")
        dateFormatter.dateFormat = "HH:mm"
        subjectLabel.text = subject.subject
        timeLabel.text = dateFormatter.string(from: subject.startTime!) + "–" + dateFormatter.string(from: subject.endTime!)
        var locationText = ""
        for location in subject.locations! {
            locationText += (location.educator ?? "Преподаватель неизвестен") + ": "
            locationText += location.building ?? "Адрес неизвестен"
            locationText += location.audience != nil ? (", " + location.audience! + "\n\n") : "\n\n"
        }
        locationLabel.text = locationText
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
