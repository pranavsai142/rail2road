//
//  ChatBubble.swift
//  Rail2Road
//
//  Created by Pranav Sai on 7/25/22.
//

import SwiftUI

struct ChatBubble: View {
    @EnvironmentObject var database: FireDatabaseReference
    @EnvironmentObject var dataConglomerate: DataConglomerate
    
    var chat: Chat
    var sent: Bool
    
    @State private var flagged: Bool = false
    
    init(chat: Chat, sent: Bool) {
        self.chat = chat
        self.sent = sent
    }
    
    private func toggleFlagChat() {
        if(!flagged) {
            database.setValue(path: ["flagged", chat.id.uuidString], value: true)
            flagged = true
        } else {
            database.setValue(path: ["flagged", chat.id.uuidString], value: false)
            flagged = false
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(dataConglomerate.getUserName(userId: chat.userId))
                    .font(.subheadline)
                    .italic()
                    .foregroundColor(.gray)
                Spacer()
                Text(dataConglomerate.dateToNumericalString(date: chat.timestamp))
                    .font(.subheadline)
                    .italic()
                    .foregroundColor(.gray)
                Button(action: {
                    toggleFlagChat()
                }, label: {
                    if(flagged) {
                        Image(systemName: "flag.fill")
                    } else {
                        Image(systemName: "flag")
                    }
                })
            }
                .padding(.leading)
                .padding(.trailing)
            HStack {
                Text(chat.message)
                    .padding()
                Spacer()
            }
                .foregroundColor(.white)
                .background(Color.blue)
                .frame(maxWidth: .infinity)
                .clipShape(Bubble(sent: sent))
                .padding(.leading)
                .padding(.trailing)
                .padding(.bottom)
            Divider()
        }
    }
}

struct Bubble: Shape {
    var sent: Bool
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, sent ? .bottomLeft: .bottomRight], cornerRadii: CGSize(width: 20, height: 20))
        
        return Path(path.cgPath)
    }
}

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        ChatBubble(chat: Chat(id: UUID(), timestamp: Date(), message: "", userId: ""), sent: true)
    }
}
