//
//  GalleryCaller.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 09/03/26.
//

import SwiftUI

struct GalleryViewCaller: PreviewProvider {
    static var previews: some View {
        let samplePhotos: [PhtModel] = [
            PhtModel(image: UIImage(systemName: "photo")!, date: Date()),
            PhtModel(image: UIImage(systemName: "photo")!, date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!),
            PhtModel(image: UIImage(systemName: "photo")!, date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!),
            PhtModel(image: UIImage(systemName: "photo")!, date: Calendar.current.date(byAdding: .month, value: -1, to: Date())!)
        ]
        
        NavigationView {
            Gallery(photos: samplePhotos)
        }
    }
}
