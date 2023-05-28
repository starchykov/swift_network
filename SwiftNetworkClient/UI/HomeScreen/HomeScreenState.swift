//
//  HomeScreenState.swift
//  SwiftNetworkClient
//
//  Created by Ivan Starchykov on 5/28/23.
//

import Foundation


struct HomeScreenState {
    let posts: Array<PostModel>
    let isLoading: Bool
    
    init(posts: [PostModel] = [], isLoading: Bool = false) {
        self.posts = posts
        self.isLoading = isLoading
    }
    
    func copyWith(posts: [PostModel]? = nil, isLoading: Bool? = nil) -> HomeScreenState {
        return HomeScreenState(
            posts: posts ?? self.posts,
            isLoading: isLoading ?? self.isLoading
        )
    }
}
