//
//  UserProfileView.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/11/23.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var settings: SettingsModel  // Make sure to pass the settings object

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                    VStack(alignment: .leading) {
                        Text(userSession.username)
                            .font(.headline)
                        Text(userSession.email)
                    }
                }
                .padding()

                Button(action: {
                    // Handle Logout
                    userSession.isLoggedIn = false
                    userSession.userRole = nil
                    userSession.selectedTab = 0  // Reset selected tab on logout
                }) {
                    Text("Logout")
                        .foregroundColor(.red)
                }
                .padding()

                NavigationLink(destination: SettingsView(settings: settings)) {  // Added the link to navigate to settings
                    Text("Settings")
                }
                .padding()

                Spacer()
            }
        }
    }
}

// Preview
struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
            .environmentObject(UserSession())
            .environmentObject(SettingsModel())
    }
}
