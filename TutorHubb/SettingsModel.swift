//
//  SettingsModel.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/11/23.
//

import SwiftUI
import Combine

class SettingsModel: ObservableObject {
    @Published var isHighContrastEnabled: Bool = false
    @Published var selectedFontSize: CGFloat = 16
}
