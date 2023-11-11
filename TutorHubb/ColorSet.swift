//
//  ColorSet.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/11/23.
//

import SwiftUI

struct ColorSet {
    static func textColor(highContrastEnabled: Bool) -> Color {
        return highContrastEnabled ? Color.white : Color.black
    }
    
    static func backgroundColor(highContrastEnabled: Bool) -> Color {
        return highContrastEnabled ? Color.black : Color.white
    }
}
