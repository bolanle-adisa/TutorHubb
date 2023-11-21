//
//  HomeView.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/11/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("TutorHub")
                    .font(.system(size: 60, weight: .black, design: .rounded)) // Increase font size, set weight and design
                    .foregroundColor(.black) // Set text color to black
                    .shadow(color: .gray, radius: 2, x: 0, y: 5) // Add shadow for depth
                    .padding(.bottom, 40)
                NavigationLink(destination: UserRoleSelectionView()) {
                    Text("Get Started")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 246 / 255, green: 206 / 255, blue: 72 / 255)) // Gold color
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                Spacer()
            }
            .padding(.top)
            .background(Color(red: 110 / 255, green: 49 / 255, blue: 44 / 255)) // Maroon color
            .edgesIgnoringSafeArea(.all)
        }
    }
}

// Preview provider
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
