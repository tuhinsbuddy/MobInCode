//
//  Gallery.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 08/03/26.
//

import SwiftUI
import SwiftData

struct Gallery: View {
    let photos: [PhtModel]
    var groupPhotos: [PhtGroup: [PhtModel]] {
        GalleryFunc.groupPhotos(photos)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                ForEach(PhtGroup.allCases, id: \.self) { group in
                    if let items = groupPhotos[group] {
                        GallerySection(title: group.rawValue, photos: items)
                    }
                }
            }
        }
        .navigationTitle("Gallery Area!")
    }
}


#Preview {
    Gallery(photos: GalleryFunc.samplePhotos).modelContainer(for: Item.self, inMemory: true)
}
