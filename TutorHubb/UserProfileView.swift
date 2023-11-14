//  UserProfileView.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/11/23.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseFirestore

struct UserProfileView: View {
    @EnvironmentObject var userSession: UserSession
    @EnvironmentObject var settings: SettingsModel // Ensure this is provided to the view
    @State private var isImagePickerPresented = false
    @State private var profileImage: UIImage?

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Button(action: {
                    isImagePickerPresented = true
                }) {
                    if let profileImage = profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    }
                }
                .sheet(isPresented: $isImagePickerPresented, onDismiss: uploadProfileImage) {
                    PhotoPicker(image: $profileImage)
                }

                VStack(alignment: .leading) {
                    Text(userSession.username)
                        .font(.headline)
                    Text(userSession.email)
                }
                .padding()

                Button(action: logoutAction) {
                    Text("Logout")
                        .foregroundColor(.red)
                }
                .padding()

                NavigationLink(destination: SettingsView(settings: settings)) {
                    Text("Settings")
                }
                .padding()

                Spacer()
            }
            .onAppear {
                            // If the user is logged in and the userId is set, try to fetch their profile image URL
                            if userSession.isLoggedIn && !userSession.userId.isEmpty {
                                userSession.fetchProfileImageUrl()
                            }
                        }
        }
    }

    func uploadProfileImage() {
        guard let image = profileImage,
              let imageData = image.jpegData(compressionQuality: 0.4),
              !userSession.userId.isEmpty else {
            print("User ID is not set")
            return
        }

        let storageRef = Storage.storage().reference(withPath: "profileImages/\(userSession.userId).jpg")

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard metadata != nil else {
                print("Error during the upload: \(error?.localizedDescription ?? "unknown error")")
                return
            }

            storageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    print("Error getting the download URL: \(error?.localizedDescription ?? "unknown error")")
                    return
                }

                self.saveProfileImageUrl(downloadURL.absoluteString)
            }
        }
    }

    func saveProfileImageUrl(_ imageUrl: String) {
        guard !userSession.userId.isEmpty else {
            print("User ID is not set")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(userSession.userId).setData(["profileImageUrl": imageUrl], merge: true) { error in
            if let error = error {
                print("Error saving profile image URL: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.userSession.profileImageUrl = imageUrl
                }
            }
        }
    }
    
    func logoutAction() {
        userSession.isLoggedIn = false
        userSession.userRole = nil
        userSession.selectedTab = 0
        // Perform additional logout if necessary, such as revoking tokens, etc.
    }
}

// Define the PhotoPicker struct here
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider else { return }
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, error in
                    DispatchQueue.main.async {
                        self.parent.image = image as? UIImage
                    }
                }
            }
        }
    }
}

// Preview
struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let userSession = UserSession()
        let settingsModel = SettingsModel()
        return UserProfileView().environmentObject(UserSession()).environmentObject(settingsModel)
    }
}
