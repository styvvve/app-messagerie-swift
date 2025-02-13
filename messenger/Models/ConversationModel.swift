//
//  ConversationModel.swift
//  messenger
//
//  Created by NGUELE Steve  on 11/02/2025.
//

import Foundation
import SwiftUI

class ConversationModel: Identifiable, Codable {
    let id: String
    let userAid: String
    let userBid: String
    var lastMessageTimestamp: Date? //recuperation de la date d'envoi du dernier message
    
    init(id: String = UUID().uuidString, userAid: String, userBid: String, lastMessageTimestamp: Date) {
        self.id = id
        self.userAid = userAid
        self.userBid = userBid
        self.lastMessageTimestamp = lastMessageTimestamp
    }
}

extension ConversationModel {
    static var sampleConversation: ConversationModel {
        let users = UserModel.sampleUsers
        return ConversationModel(
            userAid: users[0].id,
            userBid: users[1].id,
            lastMessageTimestamp: Date().addingTimeInterval(-3600)) //1 heure 
    }
}
