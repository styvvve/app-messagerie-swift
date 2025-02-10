//
//  MessageBubble.swift
//  messenger
//
//  Created by NGUELE Steve  on 09/02/2025.
//

import SwiftUI

//creer la forme
struct MessageShape: Shape {
    var isSender: Bool
    
    func path(in rect: CGRect) -> Path {
        if isSender {
            let width = rect.width
            let height = rect.height
            let path = Path { p in
                p.move(to: CGPoint(x: 25, y: height))
                p.addLine(to: CGPoint(x:  20, y: height))
                p.addCurve(to: CGPoint(x: 0, y: height - 20),
                           control1: CGPoint(x: 8, y: height),
                           control2: CGPoint(x: 0, y: height - 8))
                p.addLine(to: CGPoint(x: 0, y: 20))
                p.addCurve(to: CGPoint(x: 20, y: 0),
                           control1: CGPoint(x: 0, y: 8),
                           control2: CGPoint(x: 8, y: 0))
                p.addLine(to: CGPoint(x: width - 21, y: 0))
                p.addCurve(to: CGPoint(x: width - 4, y: 20),
                           control1: CGPoint(x: width - 12, y: 0),
                           control2: CGPoint(x: width - 4, y: 8))
                p.addLine(to: CGPoint(x: width - 4, y: height - 11))
                p.addCurve(to: CGPoint(x: width, y: height),
                           control1: CGPoint(x: width - 4, y: height - 1),
                           control2: CGPoint(x: width, y: height))
                p.addLine(to: CGPoint(x: width + 0.05, y: height - 0.01))
                p.addCurve(to: CGPoint(x: width - 11, y: height - 4),
                           control1: CGPoint(x: width - 4, y: height + 0.5),
                           control2: CGPoint(x: width - 8, y: height - 1))
                p.addCurve(to: CGPoint(x: width - 25, y: height),
                           control1: CGPoint(x: width - 16, y: height),
                           control2: CGPoint(x: width - 20, y: height))
            }
                
            return path
        }else {
            let width = rect.width
            let height = rect.height
            let path = Path { p in
                p.move(to: CGPoint(x: 25, y: height))
                p.addLine(to: CGPoint(x: width - 20, y: height))
                p.addCurve(to: CGPoint(x: width, y: height - 20),
                           control1: CGPoint(x: width - 8, y: height),
                           control2: CGPoint(x: width, y: height - 8))
                p.addLine(to: CGPoint(x: width, y: 20))
                p.addCurve(to: CGPoint(x: width - 20, y: 0),
                           control1: CGPoint(x: width, y: 8),
                           control2: CGPoint(x: width - 8, y: 0))
                p.addLine(to: CGPoint(x: 21, y: 0))
                p.addCurve(to: CGPoint(x: 4, y: 20),
                           control1: CGPoint(x: 12, y: 0),
                           control2: CGPoint(x: 4, y: 8))
                p.addLine(to: CGPoint(x: 4, y: height - 11))
                p.addCurve(to: CGPoint(x: 0, y: height),
                           control1: CGPoint(x: 4, y: height - 1),
                           control2: CGPoint(x: 0, y: height))
                p.addLine(to: CGPoint(x: -0.05, y: height - 0.01))
                p.addCurve(to: CGPoint(x: 11.0, y: height - 4.0),
                           control1: CGPoint(x: 4.0, y: height + 0.5),
                           control2: CGPoint(x: 8, y: height - 1))
                p.addCurve(to: CGPoint(x: 25, y: height),
                           control1: CGPoint(x: 16, y: height),
                           control2: CGPoint(x: 20, y: height))
                
            }
            
            return path
        }
    }
}

struct MessageBubble: View {
    
    let message: MessageModel
    
    var body: some View {
        HStack() {
            Text(message.text)
                .bold()
                .padding()
                .foregroundStyle(fontColor)
                .background(backgroundColor)
                .clipShape(MessageShape(isSender: message.whoSent == .sender))
                .frame(maxWidth: .infinity, alignment: message.whoSent == .sender ? .trailing : .leading)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
    }
    
    //MARK: Private properties
    
    private var backgroundColor: Color {
        switch message.whoSent {
        case .sender:
            return .accent
        case .receiver:
            return Color.gray.opacity(0.5)
        }
    }
    
    private var fontColor: Color {
        switch message.whoSent {
        case .sender:
            return .white
        case .receiver:
            return .black
        }
    }
}

#Preview {
    MessageBubble(message: MessageModel(date: Date.now, whoSent: .sender, text: "Hello, world", delivranceState: .sent))
}
