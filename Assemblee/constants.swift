//
//  constants.swift
//  Assemblee
//
//  Created by Manuel De Freitas on 10/14/22.
//

import Foundation
import SwiftUI

// Colors
let primaryColor: String = "PrimaryColor"
let treasuresColor: String = "treasures"
let applyColor: String = "apply"
let lifeColor: String = "life"

#if os(iOS)
let gradient = Gradient(colors: [Color(.systemGray6), Color(.systemGray4), Color(.systemGray5)])
#endif

#if os(macOS)
let gradient = Gradient(colors: [.gray])
#endif

// Images
let APP_ICON = "onboarding-image"
let CALENDAR_IMAGE = "calendar-icon"
let MEETING_IMAGE = "meeting"


// Strings
let UI_LOGIN = "Login"
let UI_SIGNUP = "Sign Up"
let congregationID = "5F29D4C5-F670-49D2-9B43-82DEE725389"
let STRING_TREASURES = "JOYAUX DE LA PAROLE DE DIEU"
let STRING_APPLY = "APPLIQUE-​TOI AU MINISTÈRE"
let STRING_LIFE = "VIE CHRÉTIENNE"
let STRING_SECONDARY = "CLASSE SECONDAIRE"
let STRING_TODAY = "Today"
let STRING_SCHEDULES = "Schedules"
