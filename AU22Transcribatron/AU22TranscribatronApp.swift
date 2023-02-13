//
//  AU22TranscribatronApp.swift
//  AU22Transcribatron
//
//  Created by Arvid Rydh on 2023-01-24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct AU22TranscribatronApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView()
                    .environmentObject(AuthViewModel())
                    .environmentObject(FirestoreManager())
            }
        }
    }
}
