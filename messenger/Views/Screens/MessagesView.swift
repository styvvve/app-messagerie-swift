//
//  ChatView.swift
//  messenger
//
//  Created by NGUELE Steve  on 10/02/2025.
//

import SwiftUI

struct MessagesView: View {
    
    //stockons l'ensemble des messages
    @State var messages: [MessageModel]
    
    var newMessage: MessageModel = MessageModel(date: Date.now, whoSent: .sender, text: "", delivranceState: .notTransmitted)
    
    @State private var newMessageText: String = ""
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(messages) { message in
                    MessageBubble(message: message)
                }
            }
            
            HStack {
                TextField("Type a message...", text: $newMessageText, axis: .vertical)
                    .textFieldStyle(PersonalizedTextFieldStyle(icon: nil, erreur: false))
                    .padding(10)
                
                Button {
                    
                }label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(.white)
                        .padding()
                        .background(.accent)
                        .clipShape(Circle())
                }
                
            }
            .padding(.vertical, 10)
            .ignoresSafeArea()
            
            //MARK: FAIRE PLUTOT UNE ZSTACK ET METTRE LE TEXTFIELD AU DESSUS AVEC UN FOND FLOUTÉ 
        }
    }
}

#Preview {
    MessagesView(messages: previewMessages)
}
