//
//  UserSession.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/11/23.
//

import Combine
import FirebaseAuth
import FirebaseFirestore

class UserSession: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var userRole: UserRole? = nil
    @Published var selectedTab: Int = 0
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var userId: String = ""
    @Published var profileImageUrl: String = ""
    @Published var appointments: [Appointment] = []

    private var db = Firestore.firestore()
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?

    init() {
        // Perform initial setup
        loadAppointments()
    }

    func fetchProfileImageUrl() {
        guard !self.userId.isEmpty else {
            print("User ID is not set")
            return
        }

        db.collection("users").document(self.userId).getDocument { [weak self] document, error in
            if let document = document, document.exists, let profileImageUrl = document.data()?["profileImageUrl"] as? String {
                DispatchQueue.main.async {
                    self?.profileImageUrl = profileImageUrl
                }
            } else {
                print("Document does not exist or error fetching document: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }

    func saveAppointment(_ appointment: Appointment) {
        guard !userId.isEmpty else {
            print("User ID is not set")
            return
        }

        var newAppointment = appointment
        newAppointment.userId = self.userId  // Set the userId for the appointment

        do {
            try db.collection("users").document(userId).collection("appointments").addDocument(from: newAppointment)
        } catch let error {
            print("Error saving appointment: \(error)")
        }
    }

    func loadAppointments() {
        guard !self.userId.isEmpty else {
            print("User ID is not set")
            self.appointments = []  // Clear appointments if no user
            return
        }

        db.collection("users").document(self.userId).collection("appointments").getDocuments { [weak self] (snapshot, error) in
            guard let self = self, let documents = snapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            self.appointments = documents.compactMap { document -> Appointment? in
                try? document.data(as: Appointment.self)
            }
        }
    }

    func deleteAppointment(at indexSet: IndexSet) {
        // Get the appointment IDs that need to be deleted
        let appointmentIds = indexSet.compactMap { self.appointments[$0].id }

        // Loop over each ID and delete the corresponding appointment from Firestore
        for appointmentId in appointmentIds {
            db.collection("users").document(self.userId).collection("appointments").document(appointmentId).delete { error in
                if let error = error {
                    print("Error deleting appointment: \(error.localizedDescription)")
                } else {
                    print("Appointment deleted successfully with ID: \(appointmentId)")
                }
            }
        }

        // Delete the appointments from the local array
        DispatchQueue.main.async {
            self.appointments.remove(atOffsets: indexSet)
        }
    }
}
