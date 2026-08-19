//
//  HomeNavigationView.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 13/08/26.
//

import SwiftUI

struct HomeNavigationView: View {
    @StateObject
    private var router = ICREngine()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView().navigationDestination(for: ICRoute.self) { route in
                destination(for: route)
            }.environmentObject(router)
        }
    }
}

private extension HomeNavigationView {
    @ViewBuilder
    private func destination(for route: ICRoute) -> some View {
        switch route {
        case .genericList:
            GenericListView(repo: GenericListRepoProtocol())
        case .contacts:
            ContactsView(repo: ContactsRepository())
        default:
            print("Coming Soon!")
            
        }
    }
}
