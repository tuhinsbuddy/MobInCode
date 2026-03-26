//
//  MainActorView.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 26/03/26.
//

import SwiftUI

struct MainActorView: View {
    var body: some View {
        List {
            ForEach((1..<1000)) { index in
                Text("\(index)").fontWeight(.medium)
            }
        }
        Button("Perform a heavy task!") {
//            sleep(2)
            Task.sleep(for: .seconds(2))
        }.buttonStyle(.borderedProminent)
            .fontWeight(.medium)
    }
}

#Preview {
    MainActorView()
}
