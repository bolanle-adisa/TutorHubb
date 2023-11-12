//
//  UserSession.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/11/23.
//

import Combine
import FirebaseAuth

class UserSession: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var userRole: UserRole? = nil
    @Published var selectedTab: Int = 0
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?

        init() {
            authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
                self?.isLoggedIn = user != nil
                // You might want to handle userRole here as well, if it depends on the user's state
            }
        }
        
        deinit {
            // Remember to remove the listener when this object is being deallocated
            if let authStateDidChangeListenerHandle = authStateDidChangeListenerHandle {
                Auth.auth().removeStateDidChangeListener(authStateDidChangeListenerHandle)
            }
        }
    }
