//
//  TodayViewController.swift
//  NextEvent
//
//  Created by Valery Kirichenko on 26/02/2019.
//  Copyright © 2019 Valery Kirichenko. All rights reserved.
//

import UIKit
import NotificationCenter
import Disk

class TodayViewController: UIViewController, NCWidgetProviding {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        /*
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentWeek = dateFormatter.string(from:
            Calendar(identifier: .iso8601).date(from:
                Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!)
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        let studyGroup = GroupsController.shared.getSelected().groupId
        let filePath = "timetable/\(studyGroup)/\(currentWeek)"
        if let week = try? Disk.retrieve(filePath, from: .sharedContainer(appGroupName: "group.dev.valery.timetable"), as: WeekInstance.self) {
            print(week.days[Calendar(identifier: .iso8601).component(.weekday, from: Date())].day.description)
        } else {
            completionHandler(NCUpdateResult.failed)
        }
         */
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
