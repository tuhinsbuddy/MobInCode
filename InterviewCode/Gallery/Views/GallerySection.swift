//
//  GallerySection.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 08/03/26.
//

import SwiftUI

struct GallerySection: View {
    let title: String
    let photos: [PhtModel]
    
    var body: some View {
        Section(header: Text(title)
            .font(.title2)
            .padding(.leading)) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(photos) { photo in
                        Image(uiImage: photo.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipped()
                            .cornerRadius(8)
                    }
                }.padding(.horizontal)
            }
    }
}
