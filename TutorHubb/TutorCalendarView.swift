//
//  TutorCalendarView.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/11/23.
//

import SwiftUI

struct TutorCalendarView: View {
    var tutor: Tutor
    var reschedulingAppointment: Appointment? // Optional appointment to reschedule
    var onRescheduleComplete: (() -> Void)? // Optional closure to execute after rescheduling is complete
    
    @EnvironmentObject var userSession: UserSession
    @State private var selectedDate: Date = Date()
    @State private var selectedTime: Date = Date()
    @State private var showingAlert = false
    @State private var navigateToAppointmentDetails = false
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        Form {
            Section(header: Text("Select Date")) {
                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
            }
            
            Section(header: Text("Select Time")) {
                DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()
            }
            
            Section {
                Button(action: { showingAlert = true }) {
                    Text(reschedulingAppointment != nil ? "Reschedule Appointment" : "Schedule Appointment")
                }
                .disabled(!isValidSelection())
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text(reschedulingAppointment != nil ? "Reschedule Appointment" : "Schedule Appointment"),
                        message: Text("Do you want to \(reschedulingAppointment != nil ? "reschedule" : "schedule") an appointment with \(tutor.firstName) \(tutor.lastName) on \(dateFormatter.string(from: selectedDate)) at \(timeFormatter.string(from: selectedTime))?"),
                        primaryButton: .default(Text("Yes"), action: {
                            if let rescheduling = reschedulingAppointment {
                                handleRescheduleConfirmation(rescheduling: rescheduling)
                            } else {
                                let newAppointment = Appointment(userId: userSession.userId, tutorName: "\(tutor.firstName) \(tutor.lastName)", date: combine(date: selectedDate, time: selectedTime))
                                userSession.saveAppointment(newAppointment)
                                navigateToAppointmentDetails = true
                            }
                        }),
                        secondaryButton: .cancel()
                    )
                }
                
                // This NavigationLink should only be activated for a new appointment, not for rescheduling
                if reschedulingAppointment == nil {
                    NavigationLink("", destination: AppointmentDetailsView(tutor: tutor, date: selectedDate, time: selectedTime, userEmail: userSession.email, username: userSession.username), isActive: $navigateToAppointmentDetails).hidden()
                }
            }
        }
        .navigationTitle("Schedule with \(tutor.firstName)")
    }
    
    func isValidSelection() -> Bool {
        return selectedDate > Date() && selectedTime > Date()
    }
    
    private func handleRescheduleConfirmation(rescheduling: Appointment) {
        if let index = userSession.appointments.firstIndex(where: { $0.id == rescheduling.id }) {
            userSession.deleteAppointment(at: IndexSet(integer: index))
        }
        
        let newAppointment = Appointment(userId: userSession.userId, tutorName: "\(tutor.firstName) \(tutor.lastName)", date: combine(date: selectedDate, time: selectedTime))
        userSession.saveAppointment(newAppointment)
        
        onRescheduleComplete?() // Call the closure to execute additional actions after rescheduling
    }
    
    private func combine(date: Date, time: Date) -> Date {
        Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date),
                                                   month: Calendar.current.component(.month, from: date),
                                                   day: Calendar.current.component(.day, from: date),
                                                   hour: Calendar.current.component(.hour, from: time),
                                                   minute: Calendar.current.component(.minute, from: time))) ?? date
    }
}
