//
//  HomeScreenViewModel.swift
//  SwiftNetworkClient
//
//  Created by Ivan Starchykov on 5/28/23.
//

import Foundation


final class HomeScreenViewModel: ObservableObject {
    
    @Published private var _state: HomeScreenState = HomeScreenState();
    
    var state: HomeScreenState {
        return _state
    }
    
    init() {
        Network.shared.tunnel = "https://"
        Network.shared.server = "jsonplaceholder.typicode.com"
        Network.shared.token = "tlsdldnsdnJJKSHDJKmndSMD<A@9I2232323"
        initialize();
    }
    
    func initialize() {
        Task {
            do {
                try await self.getAllTasks()
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func getAllTasks() async throws {
        DispatchQueue.main.async {
            self._state = self._state.copyWith(isLoading: true)
        }
        let request: Request = Request(requestType: RequestType.get, endpoint: Endpoints.getAllPosts)
        // request.parameters = ["id" : String(Int.random(in: 1...100))]
        let posts: Array<PostModel> = try await request.execute()
        DispatchQueue.main.async {
            self._state = self._state.copyWith(posts: posts, isLoading: false)
        }
    }
}
