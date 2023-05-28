//
//  HomeScreenView.swift
//  SwiftNetworkClient
//
//  Created by Ivan Starchykov on 5/28/23.
//

import Foundation
import SwiftUI


struct HomeScreenView: View {
    @ObservedObject private var viewModel: HomeScreenViewModel = HomeScreenViewModel()
    
    var body: some View {
        let state: HomeScreenState = viewModel.state
        NavigationView {
            if state.isLoading { ProgressView()}
            else {
                ScrollView {
                    ForEach(state.posts, id: \.id ) { post in
                        VStack(alignment: .leading, spacing: 15.0) {
                            Image("background")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(15)
                            HStack(alignment: .top) {
                                Text(post.title)
                                    .font(.title)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            Text(post.body)
                        }
                        .padding(15.0)
                        .background(RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.blue)
                            .shadow(radius: 12)
                        )
                        .padding(.horizontal, 15)
                        .foregroundColor(.white)
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Dashboard")
                .toolbar {
                    Button(action: { Task { try await viewModel.getAllTasks() } }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
