//
//  GalleryFunc.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 08/03/26.
//
import SwiftUI

struct GalleryFunc {
    static func groupPhotos(_ photos: [PhtModel]) -> [PhtGroup: [PhtModel]] {
        var response: [PhtGroup: [PhtModel]] = [:]
        let calendar = Calendar.current
        for photo in photos {
            if calendar.isDateInToday(photo.date) {
                response[.today, default: []].append(photo)
            } else if calendar.isDateInYesterday(photo.date) {
                response[.yesterday, default: []].append(photo)
            } else if calendar.isDate(photo.date, equalTo: Date(), toGranularity: .weekOfYear) {
                response[.thisWeek, default: []].append(photo)
            } else {
                response[.older, default: []].append(photo)
            }
        }
        return response
    }
    
    static let samplePhotos: [PhtModel] = [
        PhtModel(image: UIImage(systemName: "photo")!, date: Date()),
        PhtModel(image: UIImage(systemName: "photo")!, date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!),
        PhtModel(image: UIImage(systemName: "photo")!, date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!),
        PhtModel(image: UIImage(systemName: "photo")!, date: Calendar.current.date(byAdding: .month, value: -1, to: Date())!)
    ]
}
