//
//  SettingsView.swift
//  messenger
//
//  Created by NGUELE Steve  on 08/02/2025.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    
    @State private var showAlertForErrorDuringSignOut = false
    @State private var showSignOutAlert = false
    
    @EnvironmentObject var appSettings: AppSettings
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Button {
                showSignOutAlert = true
            }label: {
                Text("Sign out")
                    .bold()
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .alert(isPresented: $showAlertForErrorDuringSignOut) {
            Alert(
                title: Text("An error has occured"),
                message: Text("Please try again later."),
                dismissButton: .cancel()
            )
        }
        .alert(isPresented: $showSignOutAlert) {
            Alert(
                title: Text("Do you really want to sign out ?"),
                message: Text("You will be redirected to the logIn page."),
                primaryButton: .destructive(Text("Sign Out")) {
                    do {
                        try Auth.auth().signOut()
                        if appSettings.hasLoginScreenInRootView {
                            dismiss()
                        }else {
                            
                        }
                    }catch {
                        showAlertForErrorDuringSignOut = true
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    SettingsView()
}
