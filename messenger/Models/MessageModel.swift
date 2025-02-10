//
//  MessageModel.swift
//  messenger
//
//  Created by NGUELE Steve  on 09/02/2025.
//

import Foundation
import SwiftUI

enum Sender {
    case sender
    case receiver
}

enum DelivranceState {
    case sending
    case sent
    case notTransmitted
    case read(by: Sender)
}

class MessageModel: Identifiable, ObservableObject {
    let id = UUID()
    let date: Date
    let whoSent: Sender
    @Published var text: String
    @Published var delivranceState: DelivranceState
    
    init(date: Date, whoSent: Sender, text: String, delivranceState: DelivranceState) {
        self.date = date
        self.whoSent = whoSent
        self.text = text
        self.delivranceState = delivranceState
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E HH:mm" // Mon 10:00
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
    
}

let previewMessages: [MessageModel] = [
    MessageModel(date: Date(), whoSent: .sender, text: "Hey, how are you?", delivranceState: .sent),
    MessageModel(date: Date().addingTimeInterval(-3600), whoSent: .receiver, text: "I'm good, thanks! And you?", delivranceState: .sent),
    MessageModel(date: Date().addingTimeInterval(-7200), whoSent: .sender, text: "I'm doing great, just working on some stuff.", delivranceState: .sent),
    MessageModel(date: Date().addingTimeInterval(-10800), whoSent: .receiver, text: "Nice! What are you working on?", delivranceState: .sent),
    MessageModel(date: Date().addingTimeInterval(-15000), whoSent: .sender, text: "I’m working on a SwiftUI project.", delivranceState: .sent),
    MessageModel(date: Date().addingTimeInterval(-18000), whoSent: .receiver, text: "That sounds awesome! Let me know if you need help.", delivranceState: .sent),
    MessageModel(date: Date().addingTimeInterval(-20000), whoSent: .sender, text: "Sure! I’ll reach out soon.", delivranceState: .sent),
    MessageModel(date: Date().addingTimeInterval(-25000), whoSent: .receiver, text: "Looking forward to it!", delivranceState: .sent),
    MessageModel(date: Date().addingTimeInterval(-30000), whoSent: .sender, text: "By the way, have you tried the new iOS 16 features?", delivranceState: .sent),
    MessageModel(date: Date().addingTimeInterval(-36000), whoSent: .receiver, text: "I haven’t, but I’ve heard good things about it.", delivranceState: .sent)
]
