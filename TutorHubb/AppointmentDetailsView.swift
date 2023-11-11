//
//  AppointmentDetailsView.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/11/23.
//

import SwiftUI

struct AppointmentDetailsView: View {
    var tutor: Tutor
    var date: Date
    var time: Date
    
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
            Text("Tutor: \(tutor.firstName) \(tutor.lastName)")
            Text("Date: \(dateFormatter.string(from: date))")
            Text("Time: \(timeFormatter.string(from: time))")
        }
        .navigationTitle("Appointment Details")
    }
}
