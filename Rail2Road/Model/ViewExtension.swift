//
//  ViewExtension.swift
//  Rail2Road
//
//  Created by pranav on 1/23/23.
//

import SwiftUI
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
