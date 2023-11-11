//
//  Tutor.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/11/23.
//

import Foundation

struct Tutor: Identifiable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var courses: [UUID]  // IDs of courses that this tutor can teach
    // Add more properties as needed (e.g., rating, specialty, etc.)
}
