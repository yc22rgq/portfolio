//
//  SocialcademyApp.swift
//  Socialcademy
//
//  Created by Эдуард Кудянов on 6.08.23.
//

import SwiftUI
import Firebase

@main
struct SocialcademyApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            AuthView()
        }
    }
}
