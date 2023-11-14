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
    @State private var navigateToSignIn = false  // New state variable for navigation control

    let userRole: UserRole

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userSession: UserSession

    var body: some View {
        VStack {
            if let error = error {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            }

            if isSigningUp {
                ProgressView("Signing Up...")
            } else {
                CredentialsInput2(username: $username, email: $email, password: $password)
                Button(action: signUpAction) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }

            // Hidden NavigationLink to navigate to SignInView
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
                            print("Error saving username: \(error)")
                        } else {
                            // Navigate to SignInView after successful sign-up
                            self.navigateToSignIn = true
                        }
                    }
                }
            }
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
