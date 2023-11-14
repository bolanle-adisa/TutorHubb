//
//  TutorCalendarView.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/11/23.
//

import SwiftUI

struct TutorCalendarView: View {
    var tutor: Tutor

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
                Button("Schedule with \(tutor.firstName) \(tutor.lastName)") {
                    showingAlert = true
                }
                .disabled(!isValidSelection())

                NavigationLink(destination: AppointmentDetailsView(tutor: tutor, date: selectedDate, time: selectedTime, userEmail: userSession.email, username: userSession.username), isActive: $navigateToAppointmentDetails) {
                    EmptyView()
                }
                .hidden()

                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Confirm Appointment"),
                        message: Text("Do you want to schedule an appointment with \(tutor.firstName) \(tutor.lastName) on \(dateFormatter.string(from: selectedDate)) at \(timeFormatter.string(from: selectedTime))?"),
                        primaryButton: .default(Text("Yes"), action: {
                            let newAppointment = Appointment(userId: userSession.userId, tutorName: "\(tutor.firstName) \(tutor.lastName)", date: selectedDate)
                            userSession.saveAppointment(newAppointment)

                            navigateToAppointmentDetails = true
                        }),
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        .navigationTitle("Schedule with \(tutor.firstName)")
    }

    func isValidSelection() -> Bool {
        return selectedDate > Date() && selectedTime > Date()
    }
}
