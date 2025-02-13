//
//  ContentView.swift
//  messenger
//
//  Created by NGUELE Steve  on 08/02/2025.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    var body: some View {
        VStack {
            TabView {
                Tab("Chats", systemImage: "bubble.circle") {
                    ChatsView(user: UserModel.sampleUsers[0])
                }
                
                Tab("Settings", systemImage: "gear") {
                    SettingsView()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
