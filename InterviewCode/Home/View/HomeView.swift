//
//  HomeView.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 07/03/26.
//

import SwiftUI

struct HomeView: View {
    private let items = HomeList.allCases
    @EnvironmentObject private var router: ICREngine
    
    var body: some View {
        VStack {
            NavigationSplitView {
                List {
                    ForEach(items, id: \.self) { item in
                        Button(item.rawValue) {
                            router.navigate(to: item.)
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
            } detail: {
                Text("Select an item")
            }
            Text("Developed by Tuhin the noob!")
            
        }
    }
}

#Preview {
    HomeView()
}
