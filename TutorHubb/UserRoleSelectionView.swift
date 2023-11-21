//
//  UserRoleSelectionView.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/11/23.
//

import SwiftUI

struct UserRoleSelectionView: View {
    var body: some View {
        ZStack {
            // Maroon background
            Color(red: 110 / 255, green: 49 / 255, blue: 44 / 255)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                NavigationLink(destination: SignInView(userRole: .student)) {
                    Text("Student")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 246 / 255, green: 206 / 255, blue: 72 / 255)) // Gold color
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }

                NavigationLink(destination: SignInView(userRole: .tutor)) {
                    Text("Tutor")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 246 / 255, green: 206 / 255, blue: 72 / 255)) // Gold color
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            .navigationTitle("Select Your Role")
        }
    }
}

struct UserRoleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        UserRoleSelectionView()
    }
}
