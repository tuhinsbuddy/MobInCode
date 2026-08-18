//
//  HomeView.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 07/03/26.
//

import SwiftUI

struct HomeView: View {
    private let items: [String] = HomeList.allCases.map { $0.rawValue }
    
    var body: some View {
        VStack {
            NavigationSplitView {
                List {
                    ForEach(items, id: \.self) { item in
                        NavigationLink {
                            Text(CoreFunc.getSwiftFile(from: DSAProblems.DSAEasy.twoSum.fileName)?.absoluteString ?? "Empty")
                        } label: {
                            Text(item)
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
