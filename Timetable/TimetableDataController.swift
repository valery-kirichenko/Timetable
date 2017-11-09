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
    var studyGroup = ""
    let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone(abbreviation: "MSK")
    }
    
    convenience init(studyGroup: String) {
        self.init()
        self.studyGroup = studyGroup
    }
    
    func setStudyGroup(studyGroup: String) {
        self.studyGroup = studyGroup
    }
    
    func getTimetable(forWeek week: String, forceUpdate: Bool = false, completionHandler: @escaping (WeekInstance?) -> ()) {
        let filePath = "timetable/\(studyGroup)/\(week)"
        if Disk.exists(filePath, in: .caches), let weekInstance = try? Disk.retrieve(filePath, from: .caches, as: WeekInstance.self) {
            if Date().timeIntervalSince(weekInstance.updated) > 24 * 60 * 60 || forceUpdate {
                getTimetableFromNetwork(forWeek: week) { weekInstance in
                    // If network request failed
                    if weekInstance == nil && !forceUpdate {
                        completionHandler(try! Disk.retrieve(filePath, from: .caches, as: WeekInstance.self))
                    } else { // If network request succeded or update forced
                        completionHandler(weekInstance)
                    }
                }
            } else {
                print("Retrieved from cache")
                completionHandler(try! Disk.retrieve(filePath, from: .caches, as: WeekInstance.self))
            }
        } else {
            getTimetableFromNetwork(forWeek: week, completionHandler: completionHandler)
        }
    }
    
    func getTimetable(forWeek week: Date, forceUpdate: Bool = false, completionHandler: @escaping (WeekInstance?) -> ()) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        getTimetable(forWeek: dateFormatter.string(from: week), completionHandler: completionHandler)
    }
    
    private func getTimetableFromNetwork(forWeek week: String, completionHandler: @escaping (WeekInstance?) -> ()) {
        let filePath = "timetable/\(studyGroup)/\(week)"
        var events: StudentGroupEvents! = nil
        print("Network request")
        URLSession.shared.dataTask(with: URL(string: "https://timetable.spbu.ru/api/v1/groups/\(studyGroup)/events/\(week)")!) {
            data, response, err in
            guard let data = data else {
                completionHandler(nil)
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
            self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            for day in (events.days)! {
                let date = self.dateFormatter.date(from: day.day!)!
                var subjects: [SubjectInstance] = []
                for studyEvent in day.dayStudyEvents! {
                    var startTime, endTime: Date?
                    if studyEvent.start != nil {
                        startTime = self.dateFormatter.date(from: studyEvent.start!)
                    }
                    if studyEvent.end != nil {
                        endTime = self.dateFormatter.date(from: studyEvent.end!)
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
                                                    isCancelled: studyEvent.isCancelled ?? false,
                                                    isTimeChanged: studyEvent.timeWasChanged ?? false,
                                                    isLocationChanged: studyEvent.locationsWereChanged ?? false,
                                                    isEducatorChanged: studyEvent.educatorsWereReassigned ?? false,
                                                    isNew: studyEvent.isAssigned ?? false,
                                                    locations: locations.count > 0 ? locations : nil))
                }
                days.append(DayInstance(day: date, subjects: subjects))
            }
            
            let week = WeekInstance(weekMonday: events.weekMonday!, nextWeek: events.nextWeekMonday!,
                                    prevWeek: events.previousWeekMonday!, updated: Date(), days: days)
            try! Disk.save(week, to: .caches, as: filePath)
            completionHandler(week)
        }.resume()
    }
}
