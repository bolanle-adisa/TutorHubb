//
//  CalendarManager.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/13/23.
//

import EventKit

struct CalendarManager {
    
    static func addAppointmentToCalendar(tutor: Tutor, date: Date, time: Date) {
        let eventStore: EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            if (granted) && (error == nil) {
                let event: EKEvent = EKEvent(eventStore: eventStore)
                event.title = "Appointment with \(tutor.firstName) \(tutor.lastName)"
                event.startDate = combine(date: date, time: time)
                event.endDate = event.startDate.addingTimeInterval(1 * 60 * 60) // 1 hour duration
                event.notes = "Tutoring session"
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    // Handle error
                }
            } else {
                // Handle error
            }
        }
    }
    
    static func combine(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        return calendar.date(from: DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: timeComponents.hour, minute: timeComponents.minute))!
    }
    
}
