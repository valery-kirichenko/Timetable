//
//  TimetableDataController.swift
//  Timetable
//
//  Created by Valery Kirichenko on 20.09.2017.
//  Copyright © 2017 Valery Kirichenko. All rights reserved.
//

import Foundation
import Disk

public class TimetableDataController {
    let division, studyGroup: String
    
    init(division: String, studyGroup: String) {
        self.division = division
        self.studyGroup = studyGroup
    }
    
    func getTimetable(forWeek week: String, completionHandler: @escaping (WeekInstance?) -> ()) {
        let filePath = "timetable/\(division)/\(studyGroup)/\(week)"
        if Disk.exists(filePath, in: .caches) {
            print("Retrieved from cache")
            completionHandler(try! Disk.retrieve(filePath, from: .caches, as: WeekInstance.self))
        } else {
            var events: StudentGroupEvents! = nil
            print("Network request")
            URLSession.shared.dataTask(with: URL(string: "https://timetable.spbu.ru/api/v1/\(division)/studentgroup/\(studyGroup)/events?weekMonday=\(week)")!) {
                data, response, err in
                guard let data = data else {
                    return
                }
                let decoder = JSONDecoder()
                events = try! decoder.decode(StudentGroupEvents.self, from: data)
            
                print("Retrieved from network")

                if events == nil {
                    completionHandler(nil)
                    return
                }
                
                var days: [DayInstance] = []
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                dateFormatter.timeZone = TimeZone(abbreviation: "MSK")
                dateFormatter.locale = Locale(identifier: "ru_RU")
                for day in (events.days)! {
                    let date = dateFormatter.date(from: day.day!)!
                    var subjects: [SubjectInstance] = []
                    for studyEvent in day.dayStudyEvents! {
                        var startTime, endTime: Date?
                        if studyEvent.start != nil {
                            startTime = dateFormatter.date(from: studyEvent.start!)
                        }
                        if studyEvent.end != nil {
                            endTime = dateFormatter.date(from: studyEvent.end!)
                        }
                        var locations: [LocationInstance] = []
                        if studyEvent.eventLocations != nil {
                            for eventLocation in studyEvent.eventLocations! {
                                var building, audience: String?
                                if eventLocation.displayName != "", let mergedLocation = eventLocation.displayName {
                                    let splitted = mergedLocation.split(separator: ",")
                                    building = splitted[0..<(splitted.count - 1)].joined().trimmingCharacters(in: .whitespaces)
                                    audience = String(splitted[splitted.count - 1]).trimmingCharacters(in: .whitespaces)
                                }
                                building = building != "" ? building : nil
                                audience = audience != "" ? audience : nil
                                
                                locations.append(LocationInstance(building: building, audience: audience,
                                                                  educator: eventLocation.educatorsDisplayText))
                            }
                        }
                        subjects.append(SubjectInstance(startTime: startTime, endTime: endTime,
                                                        subject: studyEvent.subject ?? "Занятие неизвестно",
                                                        locations: locations.count > 0 ? locations : nil))
                    }
                    days.append(DayInstance(day: date, subjects: subjects))
                }
                
                let week = WeekInstance(weekMonday: events.weekMonday!, nextWeek: events.nextWeekMonday!,
                                    prevWeek: events.previousWeekMonday!, days: days)
                try! Disk.save(week, to: .caches, as: filePath)
                completionHandler(week)
            }.resume()
        }
    }
    
    private func networkRequest() {
        
    }
}
