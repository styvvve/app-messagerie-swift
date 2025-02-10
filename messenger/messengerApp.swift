//
//  messengerApp.swift
//  messenger
//
//  Created by NGUELE Steve  on 08/02/2025.
//

import SwiftUI
import Firebase
import FirebaseAuth

class AppSettings: ObservableObject {
    @Published var hasLoginScreenInRootView: Bool = false
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct messengerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appSettings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            if Auth.auth().currentUser == nil {
                AuthentificationView()
                    .onAppear {
                        appSettings.hasLoginScreenInRootView = true
                    }
            }else {
                HomeView()
            }
        }
        .environmentObject(appSettings)
    }
}
