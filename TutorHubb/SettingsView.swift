//
//  SettingsView.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/11/23.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: SettingsModel
    
    var body: some View {
        NavigationView {
            Form {
                Toggle(isOn: $settings.isHighContrastEnabled) {
                    Text("High Contrast Mode")
                }
                
                Stepper("Font Size: \(Int(settings.selectedFontSize))", value: $settings.selectedFontSize, in: 12...24)
            }
            .navigationTitle("Settings")
        }
    }
}

