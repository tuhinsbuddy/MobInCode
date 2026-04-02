//
//  CoreFunc.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 11/03/26.
//

import Foundation

struct CoreFunc {
    static func getSwiftFile(from playGFile: String) -> URL? {
        guard !playGFile.isEmpty, let playURL = Bundle.main.url(forResource: playGFile, withExtension: "playground") else { return nil }
        return playURL.appendingPathComponent("Contents.swift")
    }
}
