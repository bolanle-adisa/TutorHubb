//
//  Appointment.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/13/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Appointment: Codable, Identifiable {
    @DocumentID var id: String?
    var userId: String?
    var tutorName: String
    var date: Date
    // Include other relevant details
}
