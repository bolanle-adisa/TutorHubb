//
//  UserSession.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/11/23.
//

import Combine
import FirebaseAuth
import FirebaseFirestore

class UserSession: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var userRole: UserRole? = nil
    @Published var selectedTab: Int = 0
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var userId: String = "" // This will be non-optional and should be set during sign-in
    @Published var profileImageUrl: String = "" // This will hold the URL of the profile image
    
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    func fetchProfileImageUrl() {
            guard !self.userId.isEmpty else {
                print("User ID is not set")
                return
            }
            
            let db = Firestore.firestore()
            db.collection("users").document(self.userId).getDocument { [weak self] document, error in
                if let document = document, document.exists, let profileImageUrl = document.data()?["profileImageUrl"] as? String {
                    DispatchQueue.main.async {
                        self?.profileImageUrl = profileImageUrl
                    }
                } else {
                    print("Document does not exist or error fetching document: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }
}
