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
            // The condition has been inverted to check if the user is NOT logged in
            if !userSession.isLoggedIn {
                HomeView()
                    .tag(0)
            } else {
                // Logic for when the user is logged in
                switch userSession.userRole {
                case .student:
                    StudentCourseListView(courses: sampleCourses, tutors: sampleTutors)
                        .tabItem {
                            Image(systemName: "book.fill")
                            Text("Courses")
                        }
                        .tag(0)
                    
                case .tutor:
                    TutorDashboardView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Dashboard")
                        }
                        .tag(0)
                
                case .instructor:
                    InstructorDashboardView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Dashboard")
                        }
                        .tag(0)
                
                case .none:
                    // Consider removing this or handling the no role scenario more gracefully
                    Text("No role assigned")
                        .tag(0)
                }
                
                NavigationView {
                    UserProfileView()
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
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserSession())
            .environmentObject(SettingsModel())
    }
}
