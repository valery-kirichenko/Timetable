import Foundation

struct WeekInstance: Codable {
    let weekMonday, nextWeek, prevWeek: String
    let updated: Date
    let days: [DayInstance]
}

struct DayInstance: Codable {
    let day: Date
    let subjects: [SubjectInstance]
}

struct SubjectInstance: Codable {
    let startTime, endTime: Date?
    let subject: String
    let isCancelled, isTimeChanged, isLocationChanged, isEducatorChanged, isNew: Bool
    let locations: [LocationInstance]?
}

struct LocationInstance: Codable {
    let building, audience, educator: String?
}
