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
    @EnvironmentObject var settings: SettingsModel
    @State private var isImagePickerPresented = false
    @State private var profileImage: UIImage?

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                Button(action: {
                    isImagePickerPresented = true
                }) {
                    if let profileImage = profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    } else if !userSession.profileImageUrl.isEmpty, let url = URL(string: userSession.profileImageUrl), let imageData = try? Data(contentsOf: url), let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    }
                }

                .sheet(isPresented: $isImagePickerPresented, onDismiss: uploadProfileImage) {
                    PhotoPicker(image: $profileImage)
                }
                .padding(.top, 40)

                Text(userSession.username)
                    .font(.title)
                    .fontWeight(.bold)

                Text(userSession.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)

                NavigationLink(destination: SettingsView(settings: settings)) {
                    ProfileOption(title: "Settings", iconName: "gear")
                }
                .padding()

                Button(action: logoutAction) {
                    Text("Logout")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding(.horizontal)
        }
        .navigationBarTitle("Profile", displayMode: .inline)
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

    private func ProfileOption(title: String, iconName: String) -> some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.blue)
                .frame(width: 30, height: 30)
            Text(title)
                .foregroundColor(.black)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

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
        return UserProfileView().environmentObject(userSession).environmentObject(settingsModel)
    }
}
