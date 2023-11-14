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
            List {
                // Wrap your list content in a ForEach to enable onDelete
                ForEach(userSession.appointments) { appointment in
                    VStack(alignment: .leading) {
                        Text("Tutor: \(appointment.tutorName)")
                            .font(.headline)
                        Text("Date: \(appointment.date, formatter: dateFormatter)")
                            .font(.subheadline)
                    }
                }
                .onDelete(perform: delete) // Apply the onDelete here, inside the List
            }
            .navigationTitle("Appointments")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            userSession.loadAppointments()
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }
    
    private func delete(at offsets: IndexSet) {
        userSession.deleteAppointment(at: offsets)
    }
}

struct AppointmentsListView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentsListView()
            .environmentObject(UserSession())
    }
}
