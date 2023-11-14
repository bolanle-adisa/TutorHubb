//
//  AppointmentsListView.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/13/23.
//

import SwiftUI

struct AppointmentsListView: View {
    @EnvironmentObject var userSession: UserSession

    var body: some View {
        NavigationView {
            List(userSession.appointments) { appointment in
                VStack(alignment: .leading) {
                    Text("Tutor: \(appointment.tutorName)")
                        .font(.headline)
                    Text("Date: \(appointment.date, formatter: dateFormatter)")
                        .font(.subheadline)
                }
            }
            .navigationTitle("Appointments")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                userSession.loadAppointments()
            }
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }
}

struct AppointmentsListView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentsListView()
            .environmentObject(UserSession())
    }
}
