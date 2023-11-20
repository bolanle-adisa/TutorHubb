//
//  AppointmentsListView.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/13/23.
//

import SwiftUI

struct AppointmentsListView: View {
    @EnvironmentObject var userSession: UserSession
    @State private var showingActionSheet = false
    @State private var showingRescheduleView = false
    @State private var selectedAppointment: Appointment?
    @State private var tutorForRescheduling: Tutor? // Assuming you have a Tutor model related to the Appointment

    var body: some View {
        NavigationView {
            List {
                ForEach(userSession.appointments) { appointment in
                    VStack(alignment: .leading) {
                        Text("Tutor: \(appointment.tutorName)")
                            .font(.headline)
                        Text("Date: \(appointment.date, formatter: dateFormatter)")
                            .font(.subheadline)
                    }
                    .onTapGesture {
                        self.selectedAppointment = appointment
                        // Assuming you have a method to find a Tutor based on the appointment
                        self.tutorForRescheduling = findTutor(from: appointment)
                        self.showingActionSheet = true
                    }
                }
                .onDelete(perform: delete)
            }
            //.navigationTitle("Appointments")
            .navigationBarTitleDisplayMode(.inline)
            .actionSheet(isPresented: $showingActionSheet) {
                actionSheet
            }
        }
        .onAppear {
            userSession.loadAppointments()
        }
        .sheet(isPresented: $showingRescheduleView) {
                    if let tutor = tutorForRescheduling, let appointment = selectedAppointment {
                        TutorCalendarView(
                            tutor: tutor,
                            reschedulingAppointment: appointment,
                            onRescheduleComplete: {
                                // This closure is called after the appointment is rescheduled
                                userSession.loadAppointments() // Reload appointments from Firestore
                            }
                        ).environmentObject(userSession)
            }
        }

    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }
    
    private var actionSheet: ActionSheet {
        ActionSheet(title: Text("Appointment Options"), buttons: [
            .default(Text("Reschedule")) {
                // Trigger the reschedule view to open
                self.showingRescheduleView = true
            },
            .destructive(Text("Cancel Appointment")) {
                // Handle cancellation
                self.cancelAppointment()
            },
            .cancel()
        ])
    }
    
    private func delete(at offsets: IndexSet) {
        userSession.deleteAppointment(at: offsets)
    }
    
    private func cancelAppointment() {
        if let appointment = selectedAppointment,
           let index = userSession.appointments.firstIndex(where: { $0.id == appointment.id }) {
            userSession.deleteAppointment(at: IndexSet(integer: index))
            selectedAppointment = nil // Clear the selection
        }
    }
    
    private func findTutor(from appointment: Appointment) -> Tutor? {
        // Find a tutor whose name matches the tutorName in the appointment
        return sampleTutors.first {
            "\($0.firstName) \($0.lastName)" == appointment.tutorName
        }
    }
}

struct AppointmentsListView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentsListView()
            .environmentObject(UserSession())
    }
}
