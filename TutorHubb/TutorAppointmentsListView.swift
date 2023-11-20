//
//  TutorAppointmentsListView.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/20/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct TutorAppointmentsListView: View {
    @EnvironmentObject var userSession: UserSession

    var body: some View {
        List {
            // Use userSession.tutorFirstName to filter appointments
            ForEach(userSession.appointments.filter {
                $0.tutorName.lowercased().contains(userSession.tutorFirstName.lowercased())
            }) { appointment in
                VStack(alignment: .leading) {
                    Text("Student ID: \(appointment.userId ?? "Unknown")")
                        .font(.headline)
                    Text("Date: \(appointment.date, formatter: Self.dateFormatter)")
                        .font(.subheadline)
                }
            }
        }
        .navigationTitle("My Appointments")
    }

    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }
}

struct TutorAppointmentsListView_Previews: PreviewProvider {
    static var previews: some View {
        TutorAppointmentsListView()
            .environmentObject(UserSession())
    }
}
