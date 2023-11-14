//
//  AppointmentDetailsView.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/11/23.
//

import SwiftUI
import EventKit
import MessageUI

struct AppointmentDetailsView: View {
    var tutor: Tutor
    var date: Date
    var time: Date
    var userEmail: String
    var username: String

    @State private var isShowingMailComposer = false
    @State private var isMailErrorAlertPresented = false

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
        List {
            Section(header: Text("Appointment Details")) {
                HStack {
                    Text("Tutor:")
                    Spacer()
                    Text("\(tutor.firstName) \(tutor.lastName)")
                }
                HStack {
                    Text("Date:")
                    Spacer()
                    Text(dateFormatter.string(from: date))
                }
                HStack {
                    Text("Time:")
                    Spacer()
                    Text(timeFormatter.string(from: time))
                }
            }

            Section(header: Text("Actions")) {
                Button("Add to Calendar") {
                    addAppointmentToCalendar(tutor: tutor, date: date, time: time)
                }
                .foregroundColor(.blue)

                Button("Send Email Confirmation") {
                    if MFMailComposeViewController.canSendMail() {
                        isShowingMailComposer = true
                    } else {
                        isMailErrorAlertPresented = true
                    }
                }
                .foregroundColor(.green)
            }
        }
        .alert(isPresented: $isMailErrorAlertPresented) {
            Alert(
                title: Text("Unable to Send Email"),
                message: Text("Your device is not configured to send emails. Please set up a mail account in the Mail app."),
                dismissButton: .default(Text("OK"))
            )
        }
        .sheet(isPresented: $isShowingMailComposer) {
            MailComposerView(
                userEmail: userEmail,
                username: username,
                tutor: tutor,
                date: date,
                time: time
            )
        }
        .navigationTitle("Appointment Details")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(GroupedListStyle())
    }

    func addAppointmentToCalendar(tutor: Tutor, date: Date, time: Date) {
        let eventStore = EKEventStore()
        
        eventStore.requestFullAccessToEvents { (granted, error) in
            if granted {
                // ... Create and save event ...
            } else {
                // Handle access denied
            }
        }
    }
}
