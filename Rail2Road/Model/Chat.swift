//
//  Chat.swift
//  Rail2Road
//
//  Created by Pranav Sai on 7/25/22.
//
import Foundation

struct Chat: Identifiable {
    let id: UUID
    let message: String
    let sender: String
    init(id: UUID = UUID(), message: String) {
        self.id = id
        self.message = message
        self.sender = "1"
    }
}
