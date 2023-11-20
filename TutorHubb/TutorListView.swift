//
//  TutorListView.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/11/23.
//

import SwiftUI

struct TutorsListView: View {
    var tutors: [Tutor]
    var courseName: String
    @State private var isCalendarViewPresented: Bool = false
    
    var body: some View {
            List(tutors) { tutor in
                NavigationLink(destination: TutorCalendarView(tutor: tutor)) {
                    Text("\(tutor.firstName) \(tutor.lastName)")
                }
            }
            .navigationTitle("\(courseName) Tutors")
    }
}
