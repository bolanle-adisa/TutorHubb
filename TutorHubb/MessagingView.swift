//
//  MessagingView.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/21/23.
//

import SwiftUI

struct MessagingView: View {
    @State private var composedMessage: String = ""
    @EnvironmentObject var userSession: UserSession // Assuming this will be used for user details or session management

    var body: some View {
        VStack {
            // Messages list
            List {
                // Placeholder for messages
                Text("Message 1")
                Text("Message 2")
                // Dynamically load messages here
            }
            .navigationBarTitle("Chat", displayMode: .inline)
            
            // Message composition field
            HStack {
                TextField("Type a message...", text: $composedMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: CGFloat(30))
                
                // Send button
                Button(action: sendMessage) {
                    Text("Send")
                        .bold()
                        .foregroundColor(.blue)
                }
            }.frame(minHeight: CGFloat(50)).padding()
        }
    }
    
    func sendMessage() {
        // Implement your send message functionality here
        print("Message to send: \(composedMessage)")
        composedMessage = "" // Clear the text field
    }
}

struct MessagingView_Previews: PreviewProvider {
    static var previews: some View {
        MessagingView().environmentObject(UserSession()) // Add your environment object here if necessary
    }
}
