//
//  DataConglomerate.swift
//  Rail2Road
//
//  Created by Pranav Sai on 4/30/22.
//

import Foundation

final class DataConglomerate: ObservableObject {
    @Published var data: [String: Any] = [String: Any]()
    @Published var query: [String: Any] = [String: Any]()
    
}

