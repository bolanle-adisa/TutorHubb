//
//  ContentView.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/11/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var settings: SettingsModel

    var body: some View {
        TabView(selection: $userSession.selectedTab) {
            if !userSession.isLoggedIn {
                HomeView()
                    .tag(0)
            } else {
                switch userSession.userRole {
                case .student:
                    studentTabView
                case .tutor:
                    tutorTabView
                case .none:
                    Text("No role assigned")
                        .tag(0)
                }
            }
        }
    }

    private var studentTabView: some View {
        Group {
            NavigationView {
                StudentCourseListView(courses: sampleCourses, tutors: sampleTutors)
                    .navigationBarTitle("Courses", displayMode: .inline)
                    .navigationBarItems(trailing: NavigationLink(destination: MessagingView()) {
                        Image(systemName: "message")
                    })
            }
            .tabItem {
                Image(systemName: "book.fill")
                Text("Courses")
            }
            .tag(0)

            NavigationView {
                AppointmentsListView()
                    .navigationBarTitle("Appointments", displayMode: .inline)
                    .navigationBarItems(trailing: NavigationLink(destination: MessagingView()) {
                        Image(systemName: "message")
                    })
            }
            .tabItem {
                Label("Appointments", systemImage: "calendar")
            }
            .tag(1)

            NavigationView {
                UserProfileView()
                    .navigationBarTitle("Profile", displayMode: .inline)
            }
            .tabItem {
                Image(systemName: "person.crop.circle.fill")
                Text("Profile")
            }
            .tag(2)
            .environmentObject(settings)
        }
    }

    private var tutorTabView: some View {
        Group {
            NavigationView {
                AppointmentsListView()
                    .navigationBarTitle("Appointments", displayMode: .inline)
                    .navigationBarItems(trailing: NavigationLink(destination: MessagingView()) {
                        Image(systemName: "message")
                    })
            }
            .tabItem {
                Label("Appointments", systemImage: "calendar")
            }
            .tag(0)

            NavigationView {
                UserProfileView()
                    .navigationBarTitle("Profile", displayMode: .inline)
            }
            .tabItem {
                Image(systemName: "person.crop.circle.fill")
                Text("Profile")
            }
            .tag(1)
            .environmentObject(settings)
        }
    }
}

// Placeholder for MessagingView
struct MessagingView: View {
    var body: some View {
        Text("In-app messaging system to be implemented")
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserSession())
            .environmentObject(SettingsModel())
    }
}
