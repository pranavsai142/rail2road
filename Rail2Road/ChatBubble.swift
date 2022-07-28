//
//  ChatBubble.swift
//  Rail2Road
//
//  Created by Pranav Sai on 7/25/22.
//

import SwiftUI

struct ChatBubble: View {
    var chat: Chat
    var sent: Bool
    
    init(chat: Chat, sent: Bool) {
        self.chat = chat
        self.sent = sent
    }
    
    var body: some View {
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
        ChatBubble(chat: Chat(message: "hi"), sent: true)
    }
}
