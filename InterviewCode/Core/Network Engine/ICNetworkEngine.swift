//
//  ICNetworkEngine.swift
//  InterviewCode
//
//  Created by Tuhin Samui on 15/03/26.
//
import Foundation

struct ICNetworkEngine {
    static func get(for request: ICNRequest, onCompletion: (() -> ICNResponse)) {
        var response: ICNResponse = ICNResponse(code: 0)
        guard !request.url.isEmpty else { onCompletion(); return }
        
        
        return response
    }
    
    static func post(for request: ICNRequest) -> ICNResponse {
        var response: ICNResponse = ICNResponse(code: 0)
        guard !request.url.isEmpty else { return response }
        
        
        return response
    }
}


private extension ICNetworkEngine {
    private static func process(for request: ICNRequest, and type: ICNetReqType = .get) -> ICNResponse {
        
        
        
        
        
    }
}
