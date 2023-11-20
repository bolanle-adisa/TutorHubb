//
//  StudentCourseListView.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/11/23.
//

import SwiftUI

struct Course: Identifiable {
    var id = UUID()
    var name: String
}

// StudentCourseListView.swift
struct StudentCourseListView: View {
    var courses: [Course]
    var tutors: [Tutor]
    
    @State private var isShowingProfile = false
    
    var body: some View {
        NavigationView {
            List(courses) { course in
                NavigationLink(destination: TutorsListView(tutors: tutors.filter { $0.courses.contains(course.id) }, courseName: course.name)) {
                    Text(course.name)
                }
            }
            //.navigationTitle("Courses")
        }
    }
}

struct StudentCourseListView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCourses = [
            Course(name: "Mathematics"),
            Course(name: "Writing"),
            Course(name: "Resume Review"),
            Course(name: "Computer Science"),
            Course(name: "Business"),
            Course(name: "Biology"),
            Course(name: "Physics"),
            Course(name: "Chemistry"),
            Course(name: "French"),
        ]
        
        let sampleTutors = [
            Tutor(firstName: "Alice", lastName: "Johnson", courses: [sampleCourses[0].id]),
            Tutor(firstName: "Bob", lastName: "Martin", courses: [sampleCourses[0].id, sampleCourses[1].id]),
            Tutor(firstName: "Charlie", lastName: "Brown", courses: [sampleCourses[2].id]),
            Tutor(firstName: "Diana", lastName: "King", courses: [sampleCourses[1].id, sampleCourses[3].id]),
            Tutor(firstName: "Eddie", lastName: "Bauer", courses: [sampleCourses[4].id]),
            Tutor(firstName: "Fiona", lastName: "Chen", courses: [sampleCourses[2].id, sampleCourses[4].id, sampleCourses[5].id]),
            Tutor(firstName: "Greg", lastName: "Clark", courses: [sampleCourses[6].id]),
            Tutor(firstName: "Helen", lastName: "Davis", courses: [sampleCourses[7].id]),
            Tutor(firstName: "Ian", lastName: "Evans", courses: [sampleCourses[8].id]),
            // Add more tutors as per requirement
        ]
        
        StudentCourseListView(courses: sampleCourses, tutors: sampleTutors)
    }
}
