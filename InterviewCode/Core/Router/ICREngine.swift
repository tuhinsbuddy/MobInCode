//
//  ICREngine.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 13/08/26.
//

import SwiftUI
import Combine

@MainActor //It is because navigation is an UI state
final class ICREngine: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    
    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
}
