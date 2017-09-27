struct Division: Codable {
    let name, alias, oid: String
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case alias = "Alias"
        case oid = "Oid"
    }
}

struct AdmissionYear: Codable {
    let publicDivisionAlias, yearName: String
    let studyProgramId, yearNumber: Int
    let isEmpty: Bool
    
    enum CodingKeys: String, CodingKey {
        case publicDivisionAlias = "PublicDivisionAlias"
        case yearName = "YearName"
        case studyProgramId = "StudyProgramId"
        case yearNumber = "YearNumber"
        case isEmpty = "IsEmpty"
    }
}

struct StudyProgramCombination: Codable {
    let name, nameEnglish: String
    let isBiology: Bool
    let admissionYears: [AdmissionYear]
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case nameEnglish = "NameEnglish"
        case isBiology = "IsBiology"
        case admissionYears = "AdmissionYears"
    }
}

struct StudyLevel: Codable {
    let studyLevelName, studyLevelNameEnglish: String
    let hasCourse6, isMagistery: Bool
    let studyProgramCombinations: [StudyProgramCombination]
    
    enum CodingKeys: String, CodingKey {
        case studyLevelName = "StudyLevelName"
        case studyLevelNameEnglish = "StudyLevelNameEnglish"
        case hasCourse6 = "HasCourse6"
        case isMagistery = "IsMagistery"
        case studyProgramCombinations = "StudyProgramCombinations"
    }
}

struct StudyGroup: Codable {
    let studentGroupId: Int
    let studentGroupName, studentGroupStudyForm, studentGroupProfiles, publicDivisionAlias: String
    
    enum CodingKeys: String, CodingKey {
        case studentGroupId = "StudentGroupId"
        case studentGroupName = "StudentGroupName"
        case studentGroupStudyForm = "StudentGroupStudyForm"
        case studentGroupProfiles = "StudentGroupProfiles"
        case publicDivisionAlias = "PublicDivisionAlias"
    }
}

struct StudentGroupEvents: Codable {
    let previousWeekMonday, nextWeekMonday, weekDisplayText,
        viewName, weekMonday, studentGroupDisplayName, timeTableDisplayName: String?
    let isPreviousWeekReferenceAvailable, isNextWeekReferenceAvailable, isCurrentWeekReferenceAvailable: Bool?
    let studentGroupId: Int?
    let days: [StudyEventDayItem]?
    //let breadcrumb: [BreadcrumbItem]
    
    enum CodingKeys: String, CodingKey {
        case previousWeekMonday = "PreviousWeekMonday"
        case nextWeekMonday = "NextWeekMonday"
        case weekDisplayText = "WeekDisplayText"
        case viewName = "ViewName"
        case weekMonday = "WeekMonday"
        case studentGroupDisplayName = "StudentGroupDisplayName"
        case timeTableDisplayName = "TimeTableDisplayName"
        case isPreviousWeekReferenceAvailable = "IsPreviousWeekReferenceAvailable"
        case isNextWeekReferenceAvailable = "IsNextWeekReferenceAvailable"
        case isCurrentWeekReferenceAvailable = "IsCurrentWeekReferenceAvailable"
        case studentGroupId = "StudentGroupId"
        case days = "Days"
        //case breadcrumb = "Breadcrumb"
    }
}

struct Educator: Codable {
    let id: Int?
    let nameWithPost: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "Item1"
        case nameWithPost = "Item2"
    }
}

struct StudyEventLocationItem: Codable {
    let educatorsDisplayText, displayName, latitudeValue, longitudeValue: String?
    let hasEducators, isEmpty, hasGeographicCoordinates: Bool?
    let latitude, longitude: Double?
    let educatorIds: [Educator]?
    
    enum CodingKeys: String, CodingKey {
        case educatorsDisplayText = "EducatorsDisplayText"
        case displayName = "DisplayName"
        case latitudeValue = "LatitudeValue"
        case longitudeValue = "LongitudeValue"
        case hasEducators = "HasEducators"
        case isEmpty = "IsEmpty"
        case hasGeographicCoordinates = "HasGeographicCoordinates"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case educatorIds = "EducatorIds"
    }
}

struct StudyEventItem: Codable {
    let studyEventsTimeTableKindCode, electiveDisciplinesCount: Int?
    let contingentUnitName, divisionAndCourse, start, end, subject, timeIntervalString,
    dateWithTimeIntervalString, locationsDisplayText, educatorsDisplayText,
    contingentUnitsDisplayTest, displayDateAndTimeIntervalString: String?
    let isAssigned, timeWasChanged, locationsWereChanged, educatorsWereReassigned, isElective,
    hasEducators, isCancelled, hasTheSameTimeAsPreviousItem, isStudy, allDay, withinTheSameDay: Bool?
    let eventLocations: [StudyEventLocationItem]?
    let educatorIds: [Educator]?
    
    enum CodingKeys: String, CodingKey {
        case studyEventsTimeTableKindCode = "StudyEventsTimeTableKindCode"
        case electiveDisciplinesCount = "ElectiveDisciplinesCount"
        case contingentUnitName = "ContingentUnitName"
        case divisionAndCourse = "DivisionAndCourse"
        case start = "Start"
        case end = "End"
        case subject = "Subject"
        case timeIntervalString = "TimeIntervalString"
        case dateWithTimeIntervalString = "DateWithTimeIntervalString"
        case locationsDisplayText = "LocationsDisplayText"
        case educatorsDisplayText = "EducatorsDisplayText"
        case contingentUnitsDisplayTest = "ContingentUnitsDisplayTest"
        case displayDateAndTimeIntervalString = "DisplayDateAndTimeIntervalString"
        case isAssigned = "IsAssigned"
        case timeWasChanged = "TimeWasChanged"
        case locationsWereChanged = "LocationsWereChanged"
        case educatorsWereReassigned = "EducatorsWereReassigned"
        case isElective = "IsElective"
        case hasEducators = "HasEducators"
        case isCancelled = "IsCancelled"
        case hasTheSameTimeAsPreviousItem = "HasTheSameTimeAsPreviousItem"
        case isStudy = "IsStudy"
        case allDay = "AllDay"
        case withinTheSameDay = "WithinTheSameDay"
        case eventLocations = "EventLocations"
        case educatorIds = "EducatorIds"
    }
}

struct StudyEventDayItem: Codable {
    let day, dayString: String?
    let dayStudyEvents: [StudyEventItem]?
    
    enum CodingKeys: String, CodingKey {
        case day = "Day"
        case dayString = "DayString"
        case dayStudyEvents = "DayStudyEvents"
    }
}
