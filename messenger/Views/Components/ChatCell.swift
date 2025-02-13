//
//  ChatCell.swift
//  messenger
//
//  Created by NGUELE Steve  on 11/02/2025.
//

import SwiftUI

struct ChatCell: View {
    
    @State var user: UserModel
    //on lit les users dans firebase et ensuite on les stocke sous le modèle de user dans l'appli
    @State var conversation: ConversationModel
    
    //le formatteur pour la date
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E HH:mm"
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    //le message uniquement pour la preview
    //la logique voudrait que l'on récupère dans firebase le message à l'aide de son id
    @State var lastMessage: MessageModel

    var body: some View {
        HStack {
            getProfilePicture
            
            VStack(alignment: .leading) {
                HStack {
                    Text("\(user.firstName) \(user.lastname)")
                        .bold()
                        .font(.system(size: 20))
                    Spacer()
                    //affichage de l'heure du dernier message echange
                    Text(conversation.lastMessageTimestamp.map { formatter.string(from: $0) } ?? "??:??")
                        .foregroundStyle(.gray)
                }
                .padding(.vertical, 5)
                Text(lastMessage.text)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .foregroundStyle(.gray)
            }
            Spacer()
        }
    }
    
    //MARK: private subviews
    private var getProfilePicture: some View {
        VStack {
            if let image = user.profilePicture {
                Image(uiImage: image)
                    .frame(width: 75, height: 75)
                    .clipShape(Circle())
            }else {
                Circle()
                    .frame(width: 75, height: 75)
                    .foregroundStyle(Color(UIColor.systemGray3))
                    .overlay(
                        Text(user.firstName.first?.uppercased() ?? "?")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundStyle(.black.opacity(0.9))
                    )
            }
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    ChatCell(user: UserModel.sampleUsers.first!, conversation: ConversationModel.sampleConversation, lastMessage: previewMessages[0])
    //la méthode first est un optionnel
}
