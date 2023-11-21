//
//  SignUpView.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/11/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSigningUp: Bool = false
    @State private var error: String?
    @State private var navigateToSignIn = false

    let userRole: UserRole

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userSession: UserSession

    var body: some View {
        ZStack {
            // Maroon color for background
            Color(red: 110 / 255, green: 49 / 255, blue: 44 / 255)
                .edgesIgnoringSafeArea(.all)
            VStack {
                if let error = error {
                    Text(customErrorMessage(error))
                        .foregroundColor(.red)
                        .padding()
                }
                
                if isSigningUp {
                    ProgressView("Signing Up...")
                } else {
                    CredentialsInput2(username: $username, email: $email, password: $password)
                    Button(action: signUpAction) {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 246 / 255, green: 206 / 255, blue: 72 / 255)) // Gold color for button
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                
                NavigationLink("", destination: SignInView(userRole: self.userRole), isActive: $navigateToSignIn)
                    .hidden()
            }
            .padding()
            .navigationTitle("Sign Up")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
            .disabled(isSigningUp)
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

    private func signUpAction() {
        isSigningUp = true
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.isSigningUp = false
                if let error = error {
                    self.error = error.localizedDescription
                } else if let result = result {
                    let uid = result.user.uid
                    Firestore.firestore().collection("users").document(uid).setData([
                        "username": self.username
                    ]) { error in
                        if let error = error {
                            self.error = "Failed to save user data: \(error.localizedDescription)"
                        } else {
                            self.navigateToSignIn = true
                        }
                    }
                }
            }
        }
    }

    // Custom error message function
    private func customErrorMessage(_ error: String) -> String {
        // Customize this function based on specific errors
        if error.contains("network error") {
            return "Network error. Please check your connection."
        } else if error.contains("weak password") {
            return "Your password is too weak. Please choose a stronger one."
        } else if error.contains("email already in use") {
            return "This email is already in use. Please use a different email."
        } else {
            return "Error: \(error)"
        }
    }
}

struct CredentialsInput2: View {
    @Binding var username: String
    @Binding var email: String
    @Binding var password: String

    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
        }
        .padding(.bottom)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(userRole: .student)
            .environmentObject(UserSession())
    }
}
