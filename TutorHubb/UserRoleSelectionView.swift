//
//  UserRoleSelectionView.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/11/23.
//

import SwiftUI

struct UserRoleSelectionView: View {
    var body: some View {
        VStack(spacing: 20) {
            NavigationLink(destination: SignInView(userRole: .student)) {
                Text("Student")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            NavigationLink(destination: SignInView(userRole: .tutor)) {
                Text("Tutor")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
//            NavigationLink(destination: SignInView(userRole: .instructor)) {
//                Text("Instructor")
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.purple)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
        }
        .padding(.horizontal)
        .navigationTitle("Select Your Role")
    }
}

struct UserRoleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        UserRoleSelectionView()
    }
}
