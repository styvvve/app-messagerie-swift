//
//  ChatsView.swift
//  messenger
//
//  Created by NGUELE Steve  on 10/02/2025.
//

import SwiftUI

struct ChatsView: View {
    
    let user: UserModel
    
    
    @State private var showAddContactSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            List(user.contacts) { user in
                NavigationLink {
                    MessagesView(messages: previewMessages)
                }label: {
                    ChatCell(user: user, conversation: ConversationModel.sampleConversation, lastMessage: previewMessages[0])
                }
            }
            .listStyle(.plain)
            .navigationTitle(Text("My Chats"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddContactSheet = true 
                    }label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    //MARK: Private subviews
}

#Preview {
    ChatsView(user: UserModel.sampleUsers[0])
}
