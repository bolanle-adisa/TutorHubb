//
//  SignInView.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/11/23.
//

import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigationTag: UserRole?
    
    let userRole: UserRole
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userSession: UserSession

    var navigationLink: some View {
        switch userRole {
        case .student:
            return AnyView(NavigationLink("", destination: StudentCourseListView(courses: sampleCourses, tutors: sampleTutors), tag: .student, selection: $navigationTag).hidden())
        case .tutor:
            return AnyView(NavigationLink("", destination: TutorDashboardView(), tag: .tutor, selection: $navigationTag).hidden())
        case .instructor:
            return AnyView(NavigationLink("", destination: InstructorDashboardView(), tag: .instructor, selection: $navigationTag).hidden())
        }
    }

    
    var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack(spacing: 2) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                Text("Back")
            }
        }
    }
    
    var body: some View {
        VStack {
            CredentialsInput(email: $email, password: $password)
            
            Button(action: signInAction) {
                Text("Sign In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("Sign In")
        .navigationBarTitleDisplayMode(.inline)
        .background(navigationLink)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    private func signInAction() {
        // Validate credentials and sign in...
        // Once validated, update the userSession:
        userSession.isLoggedIn = true
        userSession.userRole = self.userRole
    }
}

struct CredentialsInput: View {
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .padding([.leading, .trailing, .bottom])
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $password)
                .padding([.leading, .trailing, .bottom])
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(userRole: .student)
            .environmentObject(UserSession())
    }
}

// Sample Data and other views remain the same.


// Sample Data
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

struct TutorDashboardView: View {
    var body: some View {
        Text("Tutor Dashboard")
            .navigationTitle("Dashboard")
    }
}

struct InstructorDashboardView: View {
    var body: some View {
        Text("Instructor Dashboard")
            .navigationTitle("Dashboard")
    }
}
