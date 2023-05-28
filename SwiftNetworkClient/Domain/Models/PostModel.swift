//
//  PostModel.swift
//  SwiftNetworkClient
//
//  Created by Ivan Starchykov on 5/28/23.
//

import Foundation

struct PostModel: Identifiable, Codable {
    var id: Int;
    var userId: Int;
    var title: String;
    var body: String;
    
    init(id: Int, userId: Int, title: String, body: String) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = title
    }
}
