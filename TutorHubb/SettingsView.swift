import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: SettingsModel
    @State private var enableNotifications: Bool = true
    @State private var weeklySummary: Bool = false
    @State private var darkMode: Bool = false
    @State private var language: String = "English"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Preferences")) {
                    Toggle(isOn: $enableNotifications) {
                        Text("Enable Notifications")
                    }
                    Toggle(isOn: $weeklySummary) {
                        Text("Weekly Summary Emails")
                    }
                    Picker("Language", selection: $language) {
                        Text("English").tag("English")
                        Text("Spanish").tag("Spanish")
                        // Add more languages as needed
                    }
                }

                Section(header: Text("App Settings")) {
                    Toggle(isOn: $darkMode) {
                        Text("Dark Mode")
                    }
                    Toggle(isOn: $settings.isHighContrastEnabled) {
                        Text("High Contrast Mode")
                    }
                    Stepper("Font Size: \(Int(settings.selectedFontSize))", value: $settings.selectedFontSize, in: 12...24)
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .listStyle(GroupedListStyle())
        }
    }
}
